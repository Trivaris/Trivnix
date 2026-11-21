#!/usr/bin/env bash
set -euo pipefail

repo_root=$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)
flake_uri="git+file://$repo_root?shallow=1"

output=${1:-"$repo_root/docs/index.md"}

mkdir -p "$(dirname "$output")"

nix_expr=$(cat <<'EOF'
let
  trivnix = builtins.getFlake "FLAKE_URI_PLACEHOLDER";

  # Placeholder user so Home Manager option defaults that depend on the
  # user (home.username, ...) can be evaluated.
  docUser = "<user>";

  # Host configurations now live in the private companion flake, so build a
  # minimal stub system from the exported modules purely to evaluate options.
  # trivnix.lib carries the lib.trivnix helpers the modules depend on.
  eval = trivnix.lib.nixosSystem {
    system = builtins.currentSystem;
    modules = [
      trivnix.nixosModules.external
      trivnix.nixosModules.default
      {
        # Placeholder values for options without defaults; some option
        # defaults derive from these, so they show up as `<…>` in the docs.
        host.info = {
          name = "<host.info.name>";
          configName = "<host.info.configName>";
          loginUser = docUser;
          stateVersion = trivnix.lib.trivial.release;
          architecture = builtins.currentSystem;
          monitors = { };
        };
        system.stateVersion = trivnix.lib.trivial.release;
        users.users.${docUser}.isNormalUser = true;
        home-manager.sharedModules = [ trivnix.homeModules.default ];
        home-manager.users.${docUser} = { };
      }
    ];
  };

  pkgs = eval.pkgs;
  lib = pkgs.lib;

  publicNamespaces = [ "host" "user" "vars" "theme" ];

  filterPublic = lib.filterAttrs (name: _: builtins.elem name publicNamespaces);

  hostOptions = filterPublic eval.options;
  homeOptions = filterPublic
    eval.options.home-manager.users.valueMeta.attrs.${docUser}.configuration.options;

  cleanOpt = opt: opt // { declarations = [ ]; };

  # Strip the `home-manager.users.<docUser>.` prefix from Home Manager options.
  homePrefix = [ "home-manager" "users" docUser ];
  cleanHomeOpt = opt:
    let loc = lib.drop (builtins.length homePrefix) opt.loc;
    in cleanOpt opt // { inherit loc; name = lib.showOption loc; };

  hostDoc = pkgs.nixosOptionsDoc {
    options = hostOptions;
    transformOptions = cleanOpt;
    warningsAreErrors = false;
  };

  homeDoc = pkgs.nixosOptionsDoc {
    options = homeOptions;
    transformOptions = cleanHomeOpt;
    warningsAreErrors = false;
  };

in
pkgs.runCommand "trivnix-docs" { nativeBuildInputs = [ pkgs.nixos-render-docs ]; } ''
  mkdir -p $out

  cat > $out/README.md <<'INNER_EOF'
# Trivnix Option Reference

Read more about this Repo:
- [Getting started](./getting-started.md)
- [Development](./development.md)
- [Architecture](./architecture.md)
- [Modules](./modules.md)
- [Private Integration](./private-integration.md)

Generated standalone reference from the local trivnix module tree.

This reference covers the public Trivnix namespaces: `host.preferences`, `user.preferences`, `host.theming` and derived `vars` values.

## NixOS and host options
INNER_EOF

  nixos-render-docs options commonmark \
    --manpage-urls ${pkgs.path}/doc/manpage-urls.json \
    --revision "main" \
    ${hostDoc.optionsJSON}/share/doc/nixos/options.json \
    $out/host_rendered.md

  cat $out/host_rendered.md >>$out/README.md

  printf '\n## Home Manager options\n\n' >> $out/README.md

  nixos-render-docs options commonmark \
    --manpage-urls ${pkgs.path}/doc/manpage-urls.json \
    --revision "main" \
    ${homeDoc.optionsJSON}/share/doc/nixos/options.json \
    $out/home_rendered.md

  cat $out/home_rendered.md >>$out/README.md
''
EOF
)

nix_expr="${nix_expr//FLAKE_URI_PLACEHOLDER/$flake_uri}"

store_path=$(nix build --impure --no-link --print-out-paths --expr "$nix_expr" --refresh)

cp "$store_path/README.md" "$output"
chmod +w "$output"

printf 'Generated options reference at %s\n' "$output"