# joaquinbejar/homebrew-tap

Homebrew formulae for [ai-crew-sync](https://github.com/joaquinbejar/ai-crew-sync) —
the MCP coordination bus for a team's AI coding agents.

```bash
brew install joaquinbejar/tap/ai-crew-sync
```

Installs one binary that is the server, the operator CLI and the console
client. To run the bus itself, most people want the container image instead:

```bash
docker pull ghcr.io/joaquinbejar/ai-crew-sync
```

The formula is updated automatically when a release is published.

<!-- related-projects:start -->
## Related projects

Repositories by the same author that this project depends on, and repositories that depend on it.

### Depends on

| Repository | Description |
|------------|-------------|
| [ai-crew-sync](https://github.com/joaquinbejar/ai-crew-sync) · [crates.io](https://crates.io/crates/ai-crew-sync) | Coordination bus for teams of AI coding agents (messages, tasks, presence, locks) over one Postgres-backed server. *(Homebrew formula)* |

<!-- related-projects:end -->
