1. install watch
1.1 watch -u  ==> updates the commands

2. install oh-my-zsh
2.1 install starship
2.1.1 for ec2, doesn't need sudo `curl -sS https://starship.rs/install.sh | sh -s -- -b ~/.local/bin -y`
2.2 install exa
2.3 install tidr
2.3.1 download tldr pages (how?)


3. clone dotfiles
3.2 install stow
3.3 create links for everything 
3.4 copy change_instance_type.sh to root


4 install yazi
4.1 in ubuntu - 
4.1.1 install rust - curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
4.1.2 enable cargo in shell -  . "$HOME/.cargo/env"
4.1.3 install yazi - cargo install --locked yazi-fm yazi-cli

