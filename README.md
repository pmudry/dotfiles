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

## Claude Code status line

`~/.claude/statusline.sh` prints `model · directory · git branch` at the bottom of
the Claude Code terminal. The script is managed here; `~/.claude/settings.json`
is not (it carries per-machine permissions and model choice), so
`.chezmoiscripts/run_after_claude-statusline.sh.tmpl` merges just the
`statusLine` key into it on every `chezmoi apply`. Restart Claude Code to see it.

## Optional extra CLI tools

The bootstrap installs what the shell needs to start (including `zoxide`, which powers
the `cd` → `z` alias). These extras are referenced by the config but optional — install
whichever you want with your package manager:

```bash
sudo apt install fzf bat lsd tealdeer thefuck atuin
```

## Remote workspace: `darkstar` + Herdr

All coding sessions live on one always-on server, **darkstar** (`ubuntu@195.15.229.64`,
Ubuntu 26.04). It runs a persistent [Herdr](https://herdr.dev) server; every other machine
is only a thin client that attaches to it. Panes, shells and Claude Code sessions stay on
darkstar, so the same workspace shows up from the laptop, the desktop or a phone, and a
laptop going to sleep only drops the client — agents keep working and Herdr reconnects by
itself when the network is back.

What lives on darkstar (already set up, listed so it can be rebuilt):

- these dotfiles (`chezmoi init --apply pmudry`), zsh as login shell, hostname `darkstar`
  (`hostnamectl set-hostname darkstar` + `preserve_hostname: true` in
  `/etc/cloud/cloud.cfg.d/99_hostname.cfg`, otherwise cloud-init resets it on reboot);
- the ISC repos in `~/git/isc` (cloned over HTTPS with `gh auth login` + `gh auth setup-git`,
  so `pull-all.sh` and pushes work without ssh agent forwarding);
- `herdr` (`~/.local/bin/herdr`, copied from a client with `scp`), server started by the first
  `herdr machine add` from a client;
- Claude Code (`curl -fsSL https://claude.ai/install.sh | bash`), logged in once with `claude`,
  then `herdr integration install claude` so the Herdr sidebar shows agent states.

### Attach a new client machine

1. Get the dotfiles (or `chezmoi update` if already installed) — this brings the `ds` alias.
2. Add the ssh host alias to `~/.ssh/config` (not managed by chezmoi, so do it by hand):
   ```
   Host darkstar
       HostName 195.15.229.64
       User ubuntu
       IdentityFile ~/.ssh/id_ed25519
       ServerAliveInterval 30
       ServerAliveCountMax 4
   ```
3. Authorise the machine's key on darkstar, from a machine that already has access:
   ```bash
   ssh darkstar 'cat >> ~/.ssh/authorized_keys' < ~/.ssh/id_ed25519.pub   # run on the NEW machine
   ```
   then check `ssh darkstar hostname` prints `darkstar`.
4. Install Herdr locally (same version as the server, currently 0.9.x; `herdr update` to bump)
   and register the server as a saved machine:
   ```bash
   herdr machine add darkstar --label darkstar
   herdr machine status darkstar        # expect "reachable"
   ```

### Day to day

```bash
ds                        # = herdr --remote darkstar — remote panes, local UI and clipboard
herdr                     # local Herdr; switch Local ⇄ darkstar in the sidebar (prefix+w)
ssh darkstar  →  herdr    # from a phone or any plain ssh client, no local Herdr needed
```

Detach with `ctrl+b q`; everything keeps running. Inside a darkstar pane, `claude --resume`
finds the conversations started from any other machine, because Claude Code's history is on
darkstar. Code must live on darkstar too: edit it there, or through an IDE remote mode
(VS Code Remote SSH, JetBrains Gateway), not in local clones.

### If something is off

| Symptom | Check |
|---|---|
| `ds` hangs or `! auth` in the sidebar | `ssh darkstar` must work first (key loaded in `ssh-agent`?) |
| machine shows `! error` | `herdr machine status darkstar`, then `herdr machine reconnect darkstar` |
| client/server version mismatch warning | `herdr update` locally; the server is **not** replaced automatically, run `herdr --remote darkstar --handoff` to upgrade it live |
| darkstar rebooted | panes are gone, layout is restored; reopen Claude with `claude --resume` |
| `chezmoi update` on darkstar complains about `.gitconfig` | `gh auth setup-git` writes there; `chezmoi apply --force` keeps the helper (it is in the template) |

Removing or disabling the saved machine on a client (`herdr machine remove darkstar`) only
forgets the profile; nothing stops on the server. To stop the server for real:
`ssh darkstar herdr server stop`.
