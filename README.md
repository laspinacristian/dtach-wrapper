# dtach-wrapper

`attach`: a tiny wrapper around [dtach](https://github.com/crigler/dtach) that gives it named sessions, a session list and a kill command. It is a small alternative to tmux or screen when all you want is to keep a shell alive and reattach to it later, with no panes, windows or status bar. Scrollback, mouse and clipboard stay those of your terminal.

```bash
attach work        # attach to "work", creating it if it does not exist
attach ls          # list active sessions
attach kill work   # terminate "work"
```

Detach with **Ctrl+\\**. The session keeps running and `attach work` brings you back.

## Install

```bash
curl -fsSL https://raw.githubusercontent.com/laspinacristian/dtach-wrapper/main/install.sh | bash
```

This installs `~/.local/bin/attach`. No root needed. To install elsewhere, pass `PREFIX`:

```bash
curl -fsSL https://raw.githubusercontent.com/laspinacristian/dtach-wrapper/main/install.sh | PREFIX=/usr/local/bin sudo -E bash
```

### Requirements

`attach` needs `dtach` and `fuser` (from `psmisc`). The installer warns you if they are missing:

```bash
sudo dnf install dtach psmisc     # Fedora
sudo apt install dtach psmisc     # Debian/Ubuntu
```

## Usage

| Command | What it does |
|---|---|
| `attach <name>` | Attach to session `<name>`, or create it running your `$SHELL` |
| `attach ls` | List active sessions and remove orphaned sockets |
| `attach kill <name>` | Terminate session `<name>` and everything running in it |
| `attach help` | Show usage |

- Session names may contain letters, digits, `.`, `_` and `-`.
- Sockets live in `/tmp/dtach/<name>` (directory mode `700`).
- Nesting is refused: inside a session `$DTACH_SESSION` holds its name, so you can also show it in your prompt.
- Change the detach key with `ATTACH_DETACH_KEY`, for example `export ATTACH_DETACH_KEY='^]'`.
- Ctrl+Z is passed to the program inside the session instead of suspending dtach (`dtach -z`).

## Update / uninstall

Run the install command again to update. To uninstall:

```bash
curl -fsSL https://raw.githubusercontent.com/laspinacristian/dtach-wrapper/main/install.sh | bash -s -- --uninstall
```

## License

[MIT](LICENSE)
