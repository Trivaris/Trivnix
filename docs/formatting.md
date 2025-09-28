# Formatting Rules

The default formatter is `nixfmt`. For consistency in ambiguous spots, apply these rules.

## Baseline

- Treat all oneliners as one block.
- Separate multiline blocks in an attrset with a single blank line.

Exception: Interleave oneliners with related blocks when it improves clarity. It's fine to split a group of oneliners and place some immediately before or after the multi-line blocks they conceptually belong to (e.g., values derived from a preceding `let` attrset or helpers sitting next to the block that uses them). Keep one blank line between multi-line blocks; keep related items close together even if that mixes styles.

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
Sort them alphabetically.

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

- When declaring an option, prefer the order:

```nix
mkOption {
  type = types.listOf (types.enum modules);
  default = [ ];
  example = [ "btop" ];
  description = "Advanced Configs of Cli Tools";
}
```

- Keep any manually maintained `imports` list alphabetized so that modules are easy to locate at a glance.

- When calling `import ./<file>.nix { ... }`, sort the attrset arguments alphabetically. Inside each `inherit` statement list the inherited identifiers in alphabetical order as well.

## Module arguments (home/host)

- Sort them alphabetically. Keep them in one line if nixfmt allows.
- Always keep `...` last.

Example

```nix
{
  config,
  inputs,
  lib,
  userInfos,
  ...
}:
```

```nix
{ config, lib, ... }:
```

Rationale: mirrors common NixOS/Home Manager conventions (`config, lib, pkgs, ...`) while keeping flake `inputs` nearby and extras predictable and easy to scan.

## Trailing commas in argument sets

- Do not leave a trailing comma before the closing brace of a function argument set, except if nixfmt calls for it.

Good

```nix
{ config, lib, pkgs, ... }:
```

Avoid

```nix
{ config, lib, pkgs, ..., }:
```
