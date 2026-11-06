# Development

## Development shell

The flake development shell provides `deadnix`, `nixfmt`, `shellcheck`, `statix`,
`nixd`, and Git.

```sh
nix develop
```

## Checks

Run the public flake checks with:

```sh
nix flake check
```

The repository does not currently include a Git hook. Run the check explicitly
before committing or pushing.

## Option reference

The generated option reference is written to `docs/index.md` by default. Generate
it with:

```sh
bash docs/generate.sh [output]
```

The script evaluates the local `desktop` NixOS configuration, so the private
`trivnixPrivate` input must be available. Generated output is not a checked-in
source document and must not contain secret values or private repository contents.
