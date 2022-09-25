# vim
git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
vim +PluginInstall +qall

# zsh
sh -c "$(wget -O- https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/themes/powerlevel10k
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
git clone https://github.com/ptavares/zsh-z.git ${ZSH_CUSTOM:=~/.oh-my-zsh/custom}/plugins/zsh-z
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
git clone https://github.com/zsh-users/zsh-completions ${ZSH_CUSTOM:=~/.oh-my-zsh/custom}/plugins/zsh-completions
git clone https://github.com/djui/alias-tips.git ${ZSH_CUSTOM:-$ZSH/custom}/plugins/alias-tips
git clone https://github.com/joshskidmore/zsh-fzf-history-search ${ZSH_CUSTOM:=~/.oh-my-zsh/custom}/plugins/zsh-fzf-history-search
git clone https://github.com/chisui/zsh-nix-shell.git ${ZSH_CUSTOM:=~/.oh-my-zsh/custom}/plugins/nix-shell
git clone git@github.com:spwhitt/nix-zsh-completions.git ${ZSH_CUSTOM:=~/.oh-my-zsh/custom}/plugins/nix-zsh-completions

# tmux
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
# only if tmux is already running `tmux source ~/.tmux.conf`
# tmux
# prefix + I (capital i)
