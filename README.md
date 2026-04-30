# Claude Code Spinner Verbs — Ireland Edition

> Claude Code spinner verbs in pure Dub.

When Claude Code is grinding away in your terminal, it shows a wee spinner with a verb next to it — *Pondering…*, *Crunching…*, that sort of thing. Since v2.1.23 those verbs have been customisable. So here's a Dublin-flavoured pack: 317 verbs, all generic, all gas.

## A taste

A small selection so you know what you're in for:

```
Wreckin' me head…
Givin' it socks…
Half-arsin' it…
Scarlet for ya…
Banjaxed…
Coppin' on slowly…
Sortin' a fierce pile of yokes…
Pretendin' to know what's goin' on…
Goin' for a few scoops…
Stickin' the kettle on…
Doin' a runner…
Mother of divine…
Pure bollix altogether…
Sure it'll be grand…
```

The full list is in [`spinner-verbs-dublin.json`](./spinner-verbs-dublin.json).

## Install

### One-liner (the lazy way)

**macOS / Linux**

```bash
curl -fsSL https://raw.githubusercontent.com/tabman83/claude-code-spinner-verbs-irish/master/install.sh | bash
```

**Windows (PowerShell)**

```powershell
irm https://raw.githubusercontent.com/tabman83/claude-code-spinner-verbs-irish/master/install.ps1 | iex
```

The script will:

1. Fetch the latest verbs from this repo.
2. If a `~/.claude/settings.json` already exists, ask whether to **merge** (keep your other settings) or **overwrite** (replace the file).
3. Back the existing file up to `settings.json.bak.<timestamp>` either way.

Restart Claude Code afterwards and you're sorted.

### Manual install

Open `~/.claude/settings.json` and merge in the contents of `spinner-verbs-dublin.json`:

```json
{
  "spinnerVerbs": {
    "mode": "replace",
    "verbs": [
      "Wreckin' me head",
      "Givin' it socks",
      "Scarlet for ya",
      "..."
    ]
  }
}
```

Two modes:

- `"mode": "replace"` — Claude's defaults disappear. You get only these.
- `"mode": "append"` — these get mixed in with the defaults.

## Customising

Don't like a verb? Delete the line. It's plain JSON, no compiler required.

Want more? Append your own to the array.

## License

MIT. Do what you want with it. Just don't be a langer about it.
