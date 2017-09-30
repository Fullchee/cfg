# dotfiles

### Setup
1. Install prezto (https://github.com/sorin-ionescu/prezto)
2. Backup all of your original config files
3. Clone this repo
4. Download Powerline Fonts (https://github.com/powerline/fonts)

```bash
git clone --bare https://github.com/Fullchee/cfg.git $HOME/.cfg
```
```bash
# add this to the .aliases file
alias config='/usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME'
```

```bash
config config --local status.showUntrackedFiles no
```

To change shell, use
```bash
chsh -s $(which zsh)
```

On line ~139, remove the prompt_context in the file: `.zprezto/modules/prompt/external/agnoster/agnoster.zsh-theme` to make it cleaner
