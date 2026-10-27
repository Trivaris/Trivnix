# Getting Started

Use this flake from a separate NixOS or Home Manager configuration.

## Add the input

```nix
trivnix.url = "github:<owner>/<repository>";
```

Pass the flake input to the module system used by your configuration.

## Import the module sets

```nix
{
  imports = [
    trivnix.nixosModules.default
    trivnix.nixosModules.dependencies
  ];
}
```

For Home Manager, use the corresponding `homeModules` exports:

```nix
{
  imports = [
    trivnix.homeModules.default
    trivnix.homeModules.dependencies
  ];
}
```

Use the dependency bundle when enabling modules that depend on the upstream inputs listed in [Architecture](architecture.md). Apply `trivnix.overlays.hyprqt6engine` through your system's normal overlay configuration when using the Hyprland Qt6 engine.

## Configure features

Enable a feature in the configuration layer and set its options under the relevant namespace:

```nix
{
  hostPrefs.reverseProxy.enable = true;
  hostPrefs.homepage.enable = true;
  userPrefs.git.enable = true;
}
```

The complete option names, types, defaults, and examples are listed in the [option reference](reference/README.md).

## Keep secrets outside this flake

Secret values and machine-specific metadata belong in the composing configuration and private inputs. Follow [Private integration](private-integration.md) for the supported boundary.
