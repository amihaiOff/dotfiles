# New-Mac setup

## Quick start (automated)
The whole environment is bootstrapped by one script:

```
git clone git@github.com:amihaiOff/dotfiles.git ~/dotfiles   # or via HTTPS
~/dotfiles/setup_script.sh
```

- `--dry-run`   — print every action without changing anything
- `--force=<id>` — re-run a single step (ids: precheck, xcode-clt, homebrew,
  brew-bundle, oh-my-zsh, zsh-plugins, version-managers, stow-symlinks,
  cursor-config, extras, default-shell)
- `--reset`     — forget progress and start from scratch

The script is **resumable**: progress is saved to `~/.dotfiles_setup_state`, so
if it crashes or you Ctrl-C, just run it again and it continues where it left off.

## What it does (dependency order)
1. Verify `~/dotfiles` is cloned
2. Xcode Command Line Tools → Homebrew
3. `brew bundle` (CLI tools, casks, Nerd fonts, pyenv, uv, stow)
4. Oh My Zsh → zsh plugins
5. Version managers: pyenv, uv (brew) + nvm, poetry, rust/cargo (installers).
   These run **before** symlinking `.zshrc`, which eval's them on startup.
6. `stow` symlinks: `zsh/` + `vim/` → `$HOME`, `.config/*` → `~/.config`
   (kitty excluded). Existing files are backed up to `~/.dotfiles-backup/`.
7. Cursor settings/keybindings symlink, extras, default shell

## Manual follow-ups (printed at the end)
- Generate + add a GitHub SSH key (only for pushing/private repos)
- Import the Raycast config; grant Karabiner/Shottr permissions
- Set the terminal font to a Nerd Font
- Create `~/my_utils` if you use it (it's on PYTHONPATH)
- `exec zsh` to reload
