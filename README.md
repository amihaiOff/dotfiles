# dotfiles and tools of the trade repo 
This repo contains the dotfiles with my custon configs along with documentation of the tools I use

## Tools of the Trade - Mac
1. Ghostty - terminal emulator
2. [Lightshot](#Lightshot) - screenshots
5. f.lux - blue light filter
7. karabiner - keybaord mappings
  

## Tools of the Trade - Terminal
1. Oh-my-zsh
2. yazi - need to see how to install on ubuntu
4. tldr - quick examples of how to use terminal commands
5. cheet (similar to tldr, if I need to create my own tldr, this might the one to use)
6. [eza](https://the.exa.website) - ls replacement tool. has icons that can be used with specific [fonts](https://www.nerdfonts.com) (e.g. caskaydia). custom_aliases should have an alias for `l`
7. [starship](https://starship.rs) - package for customizing termianl prompt
9. byobu_setup.sh - bash script to setup terminal byobu session. Opens a session with two windows, one for local and one for remote. 
10. ZSH plugins installation
    1. fzf-zsh -
       ```
       git clone --depth 1 https://github.com/unixorn/fzf-zsh-plugin.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/fzf-zsh-plugin
       ```
    3. zsh-autosuggestions -
       ```
       git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
       ```
    6. zsh-syntax-highlighting -
       ```
       git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
       ```
    7. zsh-z
    8. fzf-zsh-plugin
    9. fzf-tab
    ```
    git clone https://github.com/Aloxaf/fzf-tab ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/fzf-tab
    ```
    10. zsh-vi-mode
11. [bpytop](https://github.com/aristocratos/bpytop) - great htop alternative
12. [charmbracelet/glow: Render markdown on the CLI, with pizzazz! 💅🏻](https://github.com/charmbracelet/glow) - Markdown reader
13. dust - Rust based disk space analyzer. Requires `cargo` to install -- `cargo install du-dust`. Use -r to show tree top to bottom.
14. atuin - a better command history tool
---
---

## Brewfile
This file lists a bunch of tools to download and install. Run with `brew bundle --global` (after installing brew)

## Vim
- colorscheme - [everforest](https://github.com/sainnhe/everforest) (via plug in)
- statusbar - [airline](https://github.com/vim-airline/vim-airline)

## iTerm2 - deprecated
- Good set up tips can be found [here](https://www.youtube.com/watch?v=0MiGnwPdNGE)
  - Main points are Quake style terminal (dropdown from the top)
  - powerlevel 10K theme (doesn't work with starship - this is also a prompt manager)
- Good iTerm2 tips can be found [here](https://stevenpcurtis.medium.com/make-your-life-easier-with-iterm2-a-terminal-replacement-343c08fc854f)
- [To enable ctrl+F keys (for byobu)](https://apple.stackexchange.com/questions/281033/sending-ctrlfunction-key-on-iterm2)

## Lightshot
* Can cancel cmd + shift + 4 as screen shot in MacOS and make shortcut for Lightshot 
  * This will also make the screenshot button on keychron keyboards work

## Karabiner
- [Use karabiner for launching apps with shortcuts](https://www.tristanfarmer.dev/blog/using-karabiner-for-app-window-management)
  - In order to launch vivaldi use the following command: `osascript -e 'activate application \"Vivaldi\"'`
### Complex Modification
- Change left_shift+space to underscore(_)
- CapsLock to Hyper
- Hyper Application
- Left ctrl + hjkl to arrow keys Vim style

## Other
- <ins>aws_instances</ins> - lists the instance names of ec2 machines and their respective cpus count and memory. Should be given an alias to print to terminal
- <ins>byobu_cheat_sheet</ins> - command list for byobu. Should be given an alias to print to terminal.
- <ins>general_cheatsheet.vim</ins> - a command list for vim/pycharm/others - trying to combine all shortcuts in one

## System wide vim
I tried vim mode plus but it confilcts with caps -> escape and doens't have things like `wid`. For now using left ctrl + hjkl which I can
combine with `option` key to skip words or with shift to highlight words. 

## PyCharm plugins
- ideavim
- copilot
- sourcery
- atom material icons
- material theme UI
- One dark theme
- tab shifter (might not be in use)
- forest night (might not be in use)

## Using stow for symlinks
1. Create folder in this repo.
2. Use `stow -t [target_folder] [source folder]`
This will create a symlink for all files in source folder, in the target folder. Any additional files in targer folder will remain untouched. 
For any file that already exists in the target folder the operation will fail. 

## Cursor
Create a symlink for settings.json and keybindings.json in ~/Library/Application Support/Cursor/User
