{
  pkgs,
  ...
}:
let
  version = "1.18.7";
in
pkgs.stdenv.mkDerivation {
  pname = "keeweb";
  inherit version;
  src = pkgs.fetchzip {
    url = "https://github.com/keeweb/keeweb/releases/download/v${version}/KeeWeb-${version}.html.zip";
    sha256 = "sha256-DUGe6TsyyRDo7SBLW3EChpIYUSVTy2yrJjrdOl3+cbg=";
    stripRoot = false;
  };
  installPhase = ''
    mkdir -p $out
    cp -r * $out/
  '';
}