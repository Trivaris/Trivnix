# Private Integration

This repository contains public module infrastructure. The host configurations
use the private `trivnixPrivate` flake input for values that must not be stored
in this repository.

## Private input

`trivnixPrivate.nixosModules.default` is imported by each of the
`desktop`, `laptop`, and `server` configurations. It supplies private NixOS
module data such as SOPS configuration, accounts, keys, and machine metadata.

The host configurations also pass this repository's `lib` as `trivnixLib`, which
contains shared helpers such as `mkReverseProxyOption`.

## Data boundary

Modules may consume shared values such as `config.private`, `host-infos`,
`user-infos`, and `theme-prefs`. Supply those contracts from the private input
or the composing configuration layer.

Keep secret values, SOPS files, private keys, account data, and machine-specific
metadata out of this repository and out of generated documentation. Options that
require private data are documented by their public shape and integration point
only.

For the local development workflow, see [Development](development.md).
