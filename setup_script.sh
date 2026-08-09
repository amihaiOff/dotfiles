#!/usr/bin/env bash
#
# New-Mac bootstrap. Reconstructs the environment from ~/dotfiles:
# Homebrew packages, Oh My Zsh + plugins, version managers, and config
# symlinks (via GNU stow).
#
# Usage:
#   ./setup_script.sh              # run (resumes where it left off)
#   ./setup_script.sh --dry-run    # print every action, change nothing
#   ./setup_script.sh --force=<id> # re-run a single step (e.g. --force=stow-symlinks)
#   ./setup_script.sh --reset      # forget all progress and start over
#
# Resumable: each completed step id is recorded in ~/.dotfiles_setup_state.
# Re-running skips finished steps, so a crash/Ctrl-C just means "run it again".
# Steps are ordered so nothing runs before its dependencies (see STEP ORDER
# comments). macOS only.

set -euo pipefail

# ── Config ───────────────────────────────────────────────────────────
DOTFILES="${DOTFILES:-$HOME/dotfiles}"
STATE_FILE="${DOTFILES_STATE_FILE:-$HOME/.dotfiles_setup_state}"
BACKUP_DIR="$HOME/.dotfiles-backup"
NVM_VERSION="v0.40.3"
CURSOR_USER_DIR="$HOME/Library/Application Support/Cursor/User"

DRY_RUN=false
FORCE_STEP=""

# ── Pretty logging ───────────────────────────────────────────────────
c_reset=$'\033[0m'; c_blue=$'\033[34m'; c_green=$'\033[32m'
c_yellow=$'\033[33m'; c_red=$'\033[31m'; c_dim=$'\033[2m'
log()  { printf '%s==>%s %s\n' "$c_blue"  "$c_reset" "$*"; }
ok()   { printf '%s  ✓%s %s\n' "$c_green" "$c_reset" "$*"; }
skip() { printf '%s  ·%s %s%s%s\n' "$c_dim" "$c_reset" "$c_dim" "$*" "$c_reset"; }
warn() { printf '%s  !%s %s\n' "$c_yellow" "$c_reset" "$*"; }
die()  { printf '%s✗ %s%s\n' "$c_red" "$*" "$c_reset" >&2; exit 1; }

# run: execute a mutating command, or just print it in dry-run mode.
run() {
    if [ "$DRY_RUN" = true ]; then
        printf '%s    [dry-run]%s %s\n' "$c_dim" "$c_reset" "$*"
    else
        eval "$@"
    fi
}

# ── Argument parsing ─────────────────────────────────────────────────
usage() { sed -n '3,20p' "$0"; }
for arg in "$@"; do
    case "$arg" in
        --dry-run)  DRY_RUN=true ;;
        --reset)    rm -f "$STATE_FILE"; echo "Progress reset ($STATE_FILE removed)." ;;
        --force=*)  FORCE_STEP="${arg#*=}" ;;
        -h|--help)  usage; exit 0 ;;
        *)          die "Unknown argument: $arg (try --help)" ;;
    esac
done

# ── OS guard ─────────────────────────────────────────────────────────
[ "$(uname -s)" = "Darwin" ] || die "This script is macOS-only. Detected: $(uname -s)"

# ── State tracking ───────────────────────────────────────────────────
state_has() { [ -f "$STATE_FILE" ] && grep -qxF "$1" "$STATE_FILE"; }
state_add() { [ "$DRY_RUN" = true ] && return 0; touch "$STATE_FILE"; grep -qxF "$1" "$STATE_FILE" || echo "$1" >> "$STATE_FILE"; }
state_del() { [ -f "$STATE_FILE" ] && grep -vxF "$1" "$STATE_FILE" > "$STATE_FILE.tmp" 2>/dev/null && mv "$STATE_FILE.tmp" "$STATE_FILE" || true; }

if [ -n "$FORCE_STEP" ]; then
    state_del "$FORCE_STEP"
    echo "Cleared step '$FORCE_STEP' — it will run again."
fi

# step <id> <function>: run a step unless it's already recorded as done.
step() {
    local id="$1" fn="$2"
    if [ "$DRY_RUN" = false ] && state_has "$id"; then
        skip "[$id] already done"
        return 0
    fi
    log "[$id]"
    "$fn"
    state_add "$id"
}

# ── Helpers ──────────────────────────────────────────────────────────

# Put brew on PATH for this process if it's already installed.
load_brew() {
    if command -v brew >/dev/null 2>&1; then return 0; fi
    if [ -x /opt/homebrew/bin/brew ]; then
        eval "$(/opt/homebrew/bin/brew shellenv)"
    elif [ -x /usr/local/bin/brew ]; then
        eval "$(/usr/local/bin/brew shellenv)"
    fi
}

# Move a real (non-symlink) file/dir out of the way so stow won't conflict.
backup_path() {
    local target="$1"
    if [ -e "$target" ] && [ ! -L "$target" ]; then
        run "mkdir -p '$BACKUP_DIR'"
        run "mv '$target' '$BACKUP_DIR/'"
        warn "backed up existing $target -> $BACKUP_DIR/"
    fi
}

# Pre-clear conflicts for every file a stow package would create.
# Args: <source_dir> <target_dir>. Skips kitty/ and .bak/temp junk.
prep_backups() {
    local src="$1" dst="$2" rel target
    [ -d "$src" ] || return 0
    while IFS= read -r -d '' f; do
        rel="${f#"$src"/}"
        case "$rel" in
            kitty/*|*.bak|*-[0-9]*) continue ;;
        esac
        target="$dst/$rel"
        backup_path "$target"
    done < <(find "$src" -type f -print0)
}

# ── STEP ORDER (dependencies flow top-down) ──────────────────────────

# 0. precheck — dotfiles repo must already be cloned.
s_precheck() {
    [ -d "$DOTFILES" ] || die "Dotfiles repo not found at $DOTFILES.
   Clone it first, e.g.:  git clone git@github.com:amihaiOff/dotfiles.git ~/dotfiles
   (See the SSH-key note printed at the end for setting up GitHub access.)"
    ok "Found dotfiles at $DOTFILES"
}

# 1. xcode-clt — provides git + compilers that Homebrew needs.
s_xcode_clt() {
    if xcode-select -p >/dev/null 2>&1; then
        ok "Xcode Command Line Tools already installed"
        return 0
    fi
    run "xcode-select --install"
    if [ "$DRY_RUN" = false ]; then
        log "Waiting for Xcode Command Line Tools to finish installing..."
        until xcode-select -p >/dev/null 2>&1; do sleep 10; done
        ok "Xcode Command Line Tools installed"
    fi
}

# 2. homebrew — the package manager everything else depends on.
s_homebrew() {
    if command -v brew >/dev/null 2>&1 || [ -x /opt/homebrew/bin/brew ]; then
        load_brew
        ok "Homebrew already installed"
        return 0
    fi
    run '/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"'
    load_brew
}

# 4. brew-bundle — all CLI tools, casks, fonts, pyenv, uv, stow.
s_brew_bundle() {
    load_brew
    command -v brew >/dev/null 2>&1 || die "brew not on PATH; homebrew step must run first."
    run "brew bundle --file '$DOTFILES/brewfile'"
}

# 5. oh-my-zsh — depends on git/curl + zsh (all present after brew-bundle).
# KEEP_ZSHRC keeps our stowed .zshrc from being clobbered; RUNZSH/CHSH stop it
# from launching a shell or changing the login shell mid-script.
s_oh_my_zsh() {
    if [ -d "$HOME/.oh-my-zsh" ]; then
        ok "Oh My Zsh already installed"
        return 0
    fi
    run 'RUNZSH=no CHSH=no KEEP_ZSHRC=yes sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"'
}

# 6. zsh-plugins — cloned into ZSH_CUSTOM. (git and z are OMZ built-ins, so
# they are NOT cloned here; the names below match .zshrc's plugins=(...).)
s_zsh_plugins() {
    local dir="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins"
    run "mkdir -p '$dir'"
    local names=(zsh-syntax-highlighting zsh-autosuggestions fzf-zsh-plugin zsh-vi-mode fzf-tab)
    local urls=(
        "https://github.com/zsh-users/zsh-syntax-highlighting.git"
        "https://github.com/zsh-users/zsh-autosuggestions.git"
        "https://github.com/unixorn/fzf-zsh-plugin.git"
        "https://github.com/jeffreytse/zsh-vi-mode.git"
        "https://github.com/Aloxaf/fzf-tab.git"
    )
    local i
    for i in "${!names[@]}"; do
        if [ -d "$dir/${names[$i]}" ]; then
            skip "plugin ${names[$i]} already cloned"
        else
            run "git clone --depth 1 '${urls[$i]}' '$dir/${names[$i]}'"
        fi
    done
}

# 7. version-managers — MUST run before stow-symlinks: .zshrc eval's pyenv,
# atuin, starship and sources nvm/cargo unguarded, so the binaries must exist
# before the stowed .zshrc is ever sourced. pyenv + uv came via brew-bundle.
s_version_managers() {
    load_brew
    # pyenv / uv sanity (installed by brew-bundle)
    command -v pyenv >/dev/null 2>&1 && ok "pyenv present" || warn "pyenv missing (check brewfile)"
    command -v uv    >/dev/null 2>&1 && ok "uv present"    || warn "uv missing (check brewfile)"

    # nvm
    if [ -d "$HOME/.nvm" ]; then
        ok "nvm already installed"
    else
        run "curl -o- 'https://raw.githubusercontent.com/nvm-sh/nvm/$NVM_VERSION/install.sh' | PROFILE=/dev/null bash"
    fi

    # poetry
    if command -v poetry >/dev/null 2>&1 || [ -x "$HOME/.local/bin/poetry" ]; then
        ok "poetry already installed"
    else
        run "curl -sSL https://install.python-poetry.org | python3 -"
    fi

    # rust / cargo
    if command -v cargo >/dev/null 2>&1 || [ -d "$HOME/.cargo" ]; then
        ok "rust/cargo already installed"
    else
        run "curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y"
    fi
}

# 8. stow-symlinks — depends on stow (brew-bundle) + version managers.
# Backs up any conflicting real files first (notably the ~/.zshrc that
# Oh My Zsh created), then symlinks home dotfiles and ~/.config entries.
s_stow_symlinks() {
    load_brew
    command -v stow >/dev/null 2>&1 || die "stow not installed (check brewfile)."

    # Home dotfiles: zsh/ and vim/ -> $HOME
    prep_backups "$DOTFILES/zsh" "$HOME"
    prep_backups "$DOTFILES/vim" "$HOME"
    run "stow --dir='$DOTFILES' --target='$HOME' --restow zsh vim"

    # ~/.config entries. Ignore kitty (not installed) and editor backups/temp files.
    run "mkdir -p '$HOME/.config'"
    prep_backups "$DOTFILES/.config" "$HOME/.config"
    run "cd '$DOTFILES/.config' && stow --target='$HOME/.config' --restow \
        --ignore='^kitty$' --ignore='\\.bak$' --ignore='-[0-9]+$' ."
    ok "Symlinks created (existing files backed up to $BACKUP_DIR)"
}

# 9. cursor-config — outside the repo tree, so plain symlinks (not stow).
s_cursor_config() {
    run "mkdir -p '$CURSOR_USER_DIR'"
    local f
    for f in settings.json keybindings.json; do
        backup_path "$CURSOR_USER_DIR/$f"
        run "ln -sfn '$DOTFILES/cursor/$f' '$CURSOR_USER_DIR/$f'"
    done
    ok "Cursor settings + keybindings symlinked"
}

# 10. extras — autovenv plugin + make byobu helper executable.
s_extras() {
    if [ -f "$DOTFILES/extra/autovenv/autovenv.plugin.zsh" ]; then
        run "ln -sfn '$DOTFILES/extra/autovenv/autovenv.plugin.zsh' '$HOME/autovenv.plugin.zsh'"
    fi
    [ -f "$DOTFILES/extra/byobu_setup.sh" ] && run "chmod +x '$DOTFILES/extra/byobu_setup.sh'"
    ok "Extras linked"
}

# 11. default-shell — make zsh the login shell (may prompt for password).
s_default_shell() {
    local zsh_path; zsh_path="$(command -v zsh)"
    if [ "${SHELL:-}" = "$zsh_path" ]; then
        ok "zsh already the default shell"
        return 0
    fi
    run "chsh -s '$zsh_path'"
}

# 12. reminders — manual steps that can't (or shouldn't) be automated.
s_reminders() {
    cat <<'EOF'

────────────────────────────────────────────────────────────────────
 Automated setup complete.  A few manual steps remain:
────────────────────────────────────────────────────────────────────
 GitHub SSH key (only needed to push / clone private repos):
     ssh-keygen -t ed25519 -C "amihai@zyg.com"
     eval "$(ssh-agent -s)" && ssh-add ~/.ssh/id_ed25519
     pbcopy < ~/.ssh/id_ed25519.pub      # then paste at github.com/settings/keys

 Apps / config that need a GUI action:
   • Raycast   — import "Raycast 2025-03-31 11.40.23.rayconfig" (Raycast > Settings > Advanced > Import)
   • Karabiner — open Karabiner-Elements once and grant Input Monitoring / Accessibility
   • Lightshot — grant Screen Recording; optionally remap ⌘⇧4
   • Terminal  — set the font to a Nerd Font (MesloLGS or CaskaydiaCove)

 Other:
   • Create ~/my_utils (it's on PYTHONPATH in .zshrc) if you use it.
   • Install any App Store apps you rely on.

 Then reload your shell:   exec zsh
────────────────────────────────────────────────────────────────────
EOF
}

# ── Drive the steps in dependency order ──────────────────────────────
main() {
    [ "$DRY_RUN" = true ] && log "DRY RUN — no changes will be made."
    step precheck          s_precheck
    step xcode-clt         s_xcode_clt
    step homebrew          s_homebrew
    step brew-bundle       s_brew_bundle
    step oh-my-zsh         s_oh_my_zsh
    step zsh-plugins       s_zsh_plugins
    step version-managers  s_version_managers
    step stow-symlinks     s_stow_symlinks
    step cursor-config     s_cursor_config
    step extras            s_extras
    step default-shell     s_default_shell
    s_reminders   # always shown; not a tracked step
    ok "Done."
}

main
