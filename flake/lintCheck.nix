{
  runCommand,
  inputs,
  bash,
  coreutils,
  deadnix,
  findutils,
  nixfmt,
  statix,
}:
runCommand "lint"
  {
    src = inputs.self;
    nativeBuildInputs = [
      bash
      coreutils
      deadnix
      findutils
      nixfmt
      statix
    ];
  }
  ''
    cp -r "$src" repo
    chmod -R u+w repo
    cd repo

    # Run format and lint tools across all Nix files
    find . -type f -name '*.nix' -print0 | xargs -0 -r nixfmt --check
    statix check .
    deadnix --fail -- --no-cargo .

    cd - >/dev/null
    echo OK > "$out"
  ''
