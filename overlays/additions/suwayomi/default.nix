{
  inputs,
  pkgs,
}:
inputs.gradle2nix.packages.${pkgs.system}.gradle2nix {
  name = "suwayomi-server-update";

  src = inputs.suwayomi-server-src;
  lockFile = ./gradle.lockfile;

  gradleInstallFlags = [
    "server:downloadWebUI"
    "server:shadowJar"
  ];

  installPhase = ''
    mkdir -p $out/share/suwayomi-server
    cp server/build/Suwayomi-Server-*.jar $out/share/suwayomi-server/
  '';

  meta = with pkgs.lib; {
    mainProgram = "suwayomi-server";
    description = "Self-hosted manga reader server (Tachidesk fork)";
    homepage = "https://github.com/Suwayomi/Suwayomi-Server";
    license = licenses.gpl3Only;
    sourceProvenance = [ sourceTypes.fromSource sourceTypes.binaryBytecode ];
    platforms = platforms.unix;
  };
}
