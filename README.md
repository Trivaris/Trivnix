## Trivnix

Opinionated, reusable NixOS and Home Manager modules for the Trivnix configuration stack.

This flake provides:

- `nixosModules.default` - the aggregate NixOS module set
- named `nixosModules.*` exports for individual module groups and features
- `nixosConfigurations.desktop`, `nixosConfigurations.laptop`, and `nixosConfigurations.server`
- `diskoConfigurations.desktop`, `diskoConfigurations.laptop`, and `diskoConfigurations.server`
- `lib` and `overlays.default`

The host configurations use the private `trivnixPrivate` input for secrets and private
metadata. The `modules/home` tree is consumed by the repository's NixOS host
configurations; it is not currently exposed as a `homeModules` flake output.

### Documentation

- [Architecture](docs/architecture.md) - flake boundaries and exported interfaces
- [Getting started](docs/getting-started.md) - consume the modules from another flake
- [Module catalog](docs/modules.md) - features grouped by host and home use
- [Private integration](docs/private-integration.md) - public contracts with the companion flakes
- [Development](docs/development.md) - checks, formatting, and local workflows
- [Development](docs/development.md#option-reference) - generate the option reference

The modules provide sensible defaults, but remain configurable through the `host.preferences`, `user.preferences`, and related options documented in the option reference.
