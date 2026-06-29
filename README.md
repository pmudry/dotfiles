# pmudry's dotfiles

My personal config files, managed with [chezmoi](https://github.com/twpayne/chezmoi).
Stack: [Zsh](https://www.zsh.org/) + [Antigen](https://github.com/zsh-users/antigen) plugins,
[powerlevel10k](https://github.com/romkatv/powerlevel10k) theme,
[Oh My Tmux](https://github.com/gpakosz/.tmux), and a handful of
[modern-unix](https://github.com/ibraheemdev/modern-unix) tools.

## Install on a new machine

One command installs `chezmoi`, pulls this repo, and applies it:

```bash
sh -c "$(curl -fsLS get.chezmoi.io)" -- init --apply pmudry
```

This will:

1. **Prompt for your git name and email** (used to generate `~/.gitconfig`).
2. **Bootstrap the shell** — download `antigen`, install `fastfetch` and `zoxide`,
   and link the tmux config. This runs without `sudo`.
3. **Write the dotfiles** into your `$HOME`.

Then start a new shell:

```bash
zsh
```

On first launch `antigen` downloads and installs the rest of the Zsh plugins and the theme.

## Updating

**Pull the latest config onto this machine** (git pull + apply in one step):

```bash
chezmoi update
```

**Change the config and push it back:**

```bash
chezmoi cd               # jump to the source repo (~/.local/share/chezmoi)
chezmoi add <file>       # start tracking a new/changed file from $HOME
# ...edit files here...
chezmoi diff             # preview what `apply` would change in $HOME
chezmoi apply            # apply the changes locally
git commit -am "..."     # commit and push so other machines get them
git push
```

## Optional extra CLI tools

The bootstrap installs what the shell needs to start (including `zoxide`, which powers
the `cd` → `z` alias). These extras are referenced by the config but optional — install
whichever you want with your package manager:

```bash
sudo apt install fzf bat lsd tealdeer thefuck atuin
```
