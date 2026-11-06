# Getting Started

Use the exported NixOS modules from another flake or configuration.

## Add the input

```nix
trivnix.url = "github:<owner>/<repository>";
```

Pass the flake input to your NixOS module system and import the aggregate module
set:

```nix
{
  imports = [
    trivnix.nixosModules.default
  ];
}
```

Individual module groups and features are also available as named
`trivnix.nixosModules.*` outputs. Inspect the available outputs with:

```sh
nix flake show github:<owner>/<repository>
```

The repository's Home Manager modules are currently wired into its NixOS host
configurations and are not exported as a separate `homeModules` output.

## Configure features

Enable a feature in the configuration layer and set its options under the relevant namespace:

```nix
{
  host-prefs.reverse-proxy.enable = true;
  host-prefs.homepage.enable = true;
  user-prefs.git.enable = true;
}
```

The complete option names, types, defaults, and examples are listed in the
generated option reference described in [Development](development.md#option-reference).

## Keep secrets outside this flake

Secret values and machine-specific metadata belong in the private input and
configuration layer. Follow [Private integration](private-integration.md) for
the supported boundary.
