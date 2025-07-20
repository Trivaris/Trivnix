{
  inputs,
  pkgs
}:  
let
  serverRef = "v2.0.1854";
  serverHash = "sha256-oDE0b77qxTovZTd+P9J01wNxYZ3BrNqoX03biei03pM=";
  webuiRef = "r2675";
  webuiHash = "sha256-LkmS1Powt8TaGMADzT2x+PrUNpoOPzbke8yFlOaOKRM=";

  webuiZip = pkgs.fetchurl {
    url = "https://github.com/Suwayomi/Suwayomi-WebUI-preview/releases/download/${webuiRef}/Suwayomi-WebUI-${webuiRef}.zip";
    hash = webuiHash;
  };
in
{
  version = serverRef;
  revision = null;
  
  src = pkgs.fetchurl {
    url = "https://github.com/Suwayomi/Suwayomi-Server-preview/releases/download/${serverRef}/Suwayomi-Server-${serverRef}.jar";
    hash = serverHash;
  };
  
  phases = [ "installPhase" ];

  installPhase = ''
    mkdir -p $out/lib/webUI $out/bin
    ${pkgs.unzip}/bin/unzip  -q ${webuiZip} -d $out/lib/webUI

    makeWrapper ${pkgs.jdk21_headless}/bin/java $out/bin/tachidesk-server \
      --add-flags "-Dsuwayomi.tachidesk.config.server.initialOpenInBrowserEnabled=false -jar ${pkgs.jdk21_headless}"
  '';
}