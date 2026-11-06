# Private Integration

This repository is public module infrastructure. The companion `trivnixconfig` flake supplies the private composition layer.

## Companion inputs

The local configuration workflow wires these inputs into the composing flake:

- `trivnixConfigs` - concrete host and user configurations
- `trivnixLib` - shared helpers and option contracts such as host, user, and theme metadata
- `trivnixPrivate` - SOPS data, accounts, keys, and other private values
- `trivnixOverlays` - local package overlays and overrides

These names are implementation details of the companion configuration workflow, not inputs that this flake evaluates by itself.

## Data boundary

Modules may consume shared values such as `config.private`, `hostInfos`, `userInfos`, and `themingPrefs`. They may also use helpers such as `lib.mkReverseProxyOption`. Supply those contracts from the composing configuration layer.

Keep secret values, SOPS files, private keys, account data, and machine-specific metadata out of this repository and out of generated documentation. Options that require private data are documented by their public shape and integration point only.

For the local development workflow, see [Development](development.md).
