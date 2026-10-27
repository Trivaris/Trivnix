## Trivnix

Opinionated, reusable NixOS and Home Manager modules for the Trivnix configuration stack.

This flake provides:

- `nixosModules.default` - host and service modules from `host/`
- `nixosModules.dependencies` - upstream NixOS modules used by those modules
- `homeModules.default` - Home Manager modules from `home/`
- `homeModules.dependencies` - upstream Home Manager modules used by those modules
- `overlays.hyprqt6engine` - the Hyprland Qt6 engine overlay

The companion `trivnixconfig` flake composes these modules into concrete hosts and users. It also supplies the private library, secrets, metadata, and local overlay choices that this public module flake should not contain.

### Documentation

- [Architecture](docs/architecture.md) - flake boundaries and exported interfaces
- [Getting started](docs/getting-started.md) - consume the modules from another flake
- [Module catalog](docs/modules.md) - features grouped by host and home use
- [Private integration](docs/private-integration.md) - public contracts with the companion flakes
- [Development](docs/development.md) - checks, formatting, and local workflows
- [Option reference](docs/reference/README.md) - generated option reference workflow

The modules provide sensible defaults, but remain configurable through the `hostPrefs`, `userPrefs`, and related options documented in the option reference.
