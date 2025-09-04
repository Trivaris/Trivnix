pkgs:
let
  keeweb = {
    pname = "keeweb";
    version = "1.18.7";

    src = pkgs.fetchzip {
      url = "https://github.com/keeweb/keeweb/releases/download/v${keeweb.version}/KeeWeb-${keeweb.version}.html.zip";
      sha256 = "sha256-DUGe6TsyyRDo7SBLW3EChpIYUSVTy2yrJjrdOl3+cbg=";
      stripRoot = false;
    };

    installPhase = ''
      mkdir -p $out
      cp -r * $out/
    '';

    meta = {
      description = "Free cross-platform password manager compatible with KeePass ";
      homepage = "https://github.com/keeweb/keeweb";
      license = pkgs.lib.licenses.gpl3Plus;
    };
  };
in
pkgs.stdenv.mkDerivation keeweb
