{
  inputs,
  pkgs
}:  
let
  serverRef = (builtins.fromJSON (builtins.readFile (inputs.suwayomi-server-src + "/index.json"))).latest;
  webuiRef = (builtins.fromJSON (builtins.readFile (inputs.suwayomi-webui-src + "/index.json"))).latest;
  webuiZip = pkgs.fetchurl {
    url = "https://github.com/Suwayomi/Suwayomi-WebUI-preview/releases/download/${webuiRef}/Suwayomi-WebUI-${webuiRef}.zip";
    hash = "sha256-bKud2Vdq2aT6clylzRQqXbdyoZjikwmCcvEINhsu+Yo=";
  };
  
  jdk = pkgs.jdk21_headless;
  unzip = pkgs.unzip;
in
{
  version = serverRef;
  revision = null;
  
  src = pkgs.fetchurl {
    url = "https://github.com/Suwayomi/Suwayomi-Server-preview/releases/download/${serverRef}/Suwayomi-Server-${serverRef}.jar";
    hash = "sha256-HYCjj7gbIsip4z/JVw+Zu258TYGo/N1ccov+2YpO64E=";
  };
  
  buildPhase = ''
    runHook preBuild

    mkdir -p $out/lib
    ${unzip}/bin/unzip -q ${webuiZip} -d $out/lib/webUI

    makeWrapper ${jdk}/bin/java $out/bin/tachidesk-server \
      --add-flags "-Dsuwayomi.tachidesk.config.server.initialOpenInBrowserEnabled=false -jar $src"

    runHook postBuild
  '';
}