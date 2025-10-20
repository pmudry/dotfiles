# pmudry's dotfiles

> Based on HHousen's configuration files managed by [chezmoi](https://github.com/twpayne/chezmoi). Uses [Zsh](https://en.wikipedia.org/wiki/Z_shell), [Antigen](https://github.com/zsh-users/antigen) for plugin management, [Oh My Zsh](https://github.com/ohmyzsh/ohmyzsh/) for plugins and themes, [powerlevel10k](https://github.com/romkatv/powerlevel10k) as the theme, [Oh My Tmux](https://github.com/gpakosz/.tmux) for custom tmux configuration, [Atuin](https://github.com/atuinsh/atuin) for terminal history, and some tools from [modern-unix](https://github.com/ibraheemdev/modern-unix).

## Installation/Setup

Before following the installation steps below, create the file `~/.config/chezmoi/chezmoi.toml` with the following content:

```toml
[data]        
    git_email="pmudry@gmail.com"
    git_name="Pierre-André Mudry"
```

This file defines variables to be used by [`chezmoi`'s templates](https://github.com/twpayne/chezmoi/blob/master/docs/HOWTO.md#use-templates).

Explanation of the options:

- `git_email` and `git_name`: Global git user email and name set in `~/.gitconfig`.

### One Command

Run `sh -c "$(curl -fsLS git.io/chezmoi)" -- init --apply pmudry` to get everything downloaded and installed or follow the individual steps below.

### Individual Steps

1. Install `chezmoi` by following [chezmoi's install guide](https://github.com/twpayne/chezmoi/blob/master/docs/INSTALL.md). You can learn more about `chezmoi` by reading their [quick start guide](https://github.com/twpayne/chezmoi/blob/master/docs/QUICKSTART.md) or [how-to guide](https://github.com/twpayne/chezmoi/blob/master/docs/HOWTO.md).

2. Initialize `chezmoi` using this repository: `chezmoi init https://github.com/pmudry/dotfiles.git`.

3. Preview changes that `chezmoi` would make to your `$HOME`: `chezmoi diff`.

4. Apply the changes: `chezmoi apply`. This will automatically install antigen and packages required for certain plugins using the [run_once_install-packages.sh](run_once_install-packages.sh) script. Upon the first launch, `antigen` will initialize and install everything else.

5. Launch zsh: `zsh`.

## Included tools

- [zsh](https://www.zsh.org/) as the shell
- [chezmoi](https://github.com/twpayne/chezmoi) for dotfiles management
- [Oh My Zsh](https://github.com/ohmyzsh/ohmyzsh/) for plugins and themes
- [Antigen](https://github.com/zsh-users/antigen) for plugin management
- [powerlevel10k](https://github.com/romkatv/powerlevel10k) as the theme
- [Oh My Tmux](https://github.com/gpakosz/.tmux) for custom tmux configuration
- [Atuin](https://github.com/atuinsh/atuin) for terminal history
- [zoxide](https://github.com/ajeetdsouza/zoxide) for a smarter `cd` command
- [bat](https://github.com/sharkdp/bat) for a better `cat` command

## Workflow

1. Run `chezmoi add <file>` to add files to the chezmoi repo.
2. Edit files in `~/.local/share/chezmoi` or wherever the chezmoi repo is (`chezmoi cd` to find out).
3. Git commit (and eventually push) the changes.
4. Run `chezmoi diff` to preview the changes that will be made to your `$HOME`.
5. Run `chezmoi apply` to apply the changes to your `$HOME`.
