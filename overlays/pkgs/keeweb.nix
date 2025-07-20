{
  pkgs,
  ...
}:
pkgs.stdenv.mkDerivation {
  pname = "keeweb";
  version = "1.18.7";

  src = pkgs.fetchzip {
    url = "https://github.com/keeweb/keeweb/releases/download/v${version}/KeeWeb-${version}.html.zip";
    sha256 = "sha256-DUGe6TsyyRDo7SBLW3EChpIYUSVTy2yrJjrdOl3+cbg=";
    stripRoot = false;
  };
  
  installPhase = ''
    mkdir -p $out
    cp -r * $out/
  '';

  meta = with pkgs.lib; {
    description = "Free cross-platform password manager compatible with KeePass ";
    homepage = "https://github.com/keeweb/keeweb";
    license = licenses.gpl3Plus;
  };
}