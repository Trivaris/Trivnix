# Formatting Rules

The default formatter is `nixfmt`. For consistency in ambiguous spots, apply these rules.

## Baseline

- Treat all oneliners as one block.
- Separate multiline blocks in an attrset with a single blank line.

Example

```nix
{
  foo = "bar";
  baz = "bum";

  nix = {
    awesome = true;
    hello = "world";
  };
}
```

## Inherit statements

Group `inherit` statements into one multiline block unless there is exactly one oneliner or one inherit, in which case they can be inline with surrounding code.

```nix
{
  inherit (lib) nameValuePair;
  inherit (x) y;

  foo = "bar";
  baz = "bum";
}
```

Counterexamples

```nix
{
  inherit (lib) nameValuePair;
  hello = "world";
  baz = "bum";

  foo = {
    bar = "bum";
    x = "y";
  };
}
```

```nix
{
  inherit (lib) nameValuePair;
  inherit (hello) world;
  baz = "bum";

  foo = {
    bar = "bum";
    x = "y";
  };
}
```

## One oneliner + one block

If there is only one oneliner and one block, do not insert a blank line between them.

```nix
{
  foo = "bar";
  nix = {
    awesome = true;
    hello = "world";
  };
}
```

## Project-specific

- Modules that define both `options` and `config` must separate those top-level attrs by one blank line.

```nix
{
  options.hostPrefs.steam.enable = mkEnableOption "Enable Steam";

  config = mkIf prefs.steam.enable {
    programs.steam = {
      enable = true;
      package = pkgs.steam-millennium;
      extraCompatPackages = [ pkgs.proton-ge-bin ];
      extraPackages = [ pkgs.gamescope ];
      protontricks.enable = true;
      extest.enable = true;
    };
  };
}
```

- When declaring an option, prefer the order:

```nix
mkOption {
  type = types.listOf (types.enum modules);
  default = [ ];
  example = [ "btop" ];
  description = "Advanced Configs of Cli Tools";
}
```

- For `programs.<name>`, put the primary configuration first; then supporting attributes.

```nix
{
  programs = {
    eza = {
      enable = true;
      extraOptions = [ "-l" "--icons" "--git" "-a" ];
    };

    fish.functions.ls.body = "eza $argv";

    foo = {
      baz = "bar";
      hello = "world";
    };
  };
}
```

## Module arguments (home/host)

- Order module arguments as: `config, lib, pkgs, inputs, <extras...>, ...`.
- Place extras (project-specific args like `trivnixLib`, `hostInfos`, `userInfos`, `hostPrefs`, etc.) alphabetically after the standard ones.
- Always keep `...` last.

Example

```nix
{ config, lib, pkgs, inputs, hostInfos, hostPrefs, trivnixLib, ... }:
```

Rationale: mirrors common NixOS/Home Manager conventions (`config, lib, pkgs, ...`) while keeping flake `inputs` nearby and extras predictable and easy to scan.

## Trailing commas in argument sets

- Do not leave a trailing comma before the closing brace of a function argument set.

Good

```nix
{ config, lib, pkgs, ... }:
```

Avoid

```nix
{ config, lib, pkgs, ..., }:
```
