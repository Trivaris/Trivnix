{
  pkgs,
  ...
}:
let
  inherit (pkgs.lib) licenses;
  ksud = {
    pname = "ksud";
    version = "v1.0.5";

    dontUnpack = true;

    src = pkgs.fetchurl {
      url = "https://github.com/tiann/KernelSU/releases/download/${ksud.version}/ksud-x86_64-unknown-linux-musl";
      sha256 = "sha256-3cne0GBqlOMGEVWkugIszwXWUGuNDDNRrOvkOc5sYic=";
    };

    installPhase = ''
      mkdir -p $out/bin
      install -m755 $src $out/bin/ksud
    '';

    meta = {
      description = "KernelSU daemon (prebuilt musl x86_64 binary)";
      homepage = "https://github.com/tiann/KernelSU";
      license = licenses.gpl3Only;
      platforms = [ "x86_64-linux" ];
    };
  };
in
pkgs.stdenv.mkDerivation ksud
