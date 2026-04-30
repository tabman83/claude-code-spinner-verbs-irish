# Claude Code Spinner Verbs — Ireland Edition

> Claude Code spinner verbs in pure Dub.

When Claude Code is grinding away in your terminal, it shows a wee spinner with a verb next to it — *Pondering…*, *Crunching…*, that sort of thing. Since v2.1.23 those verbs have been customisable. So here's a Dublin-flavoured pack: 317 verbs, all generic, all gas.

## Install

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

Restart Claude Code and you're sorted.

## Customising

Don't like a verb? Delete the line. It's plain JSON, no compiler required.

Want more? Append your own to the array.

## License

MIT. Do what you want with it. Just don't be a langer about it.
