# Development

## Development shell

The flake development shell provides `deadnix`, `nixfmt`, `shellcheck`, `statix`, `nixd`, and Git.

```sh
nix develop
```

## Checks

Run the public flake checks with:

```sh
nix flake check
```

The pre-push hook runs the same check and blocks a push when it fails. The local shell helpers can run checks and rebuilds against sibling development inputs, including `trivnixConfigs`, `trivnixLib`, `trivnixPrivate`, and `trivnixOverlays`.

Enable the repository hooks once per checkout:

```sh
git config core.hooksPath .githooks
```

Use the production mode for the configured flake inputs, or the default local mode while developing the companion flakes.

## Option reference

The generated option reference is kept in `docs/reference/README.md`. Generate it from the local companion configuration with:

```sh
bash docs/reference/generate.sh [host] [output]
```

The default host is `server`, and the default companion flake path is `../trivnixconfigs`. Set `TRIVNIX_CONFIG_FLAKE` to use another checkout. Generated output must not contain secret values or private repository contents.

The pre-push hook runs this command before `nix flake check`. If the output changes, the hook updates the working tree and stops the push. Commit the generated README and push again.
