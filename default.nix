{ lib, stdenv, gradle, makeWrapper, fetchFromGitHub }:

stdenv.mkDerivation (finalAttrs: {
  name = "suwayomi-server-new";

  src = fetchFromGitHub {
    owner = "Suwayomi";
    repo = "Suwayomi-Server";
    rev = "22df7e307427953ef5016cf3d24cfde9903d0101";
    hash = "sha256-Xe7RCsrEyvyv2g7ZyfDNs5koL/C2powh02RDIDggkSQ=";
  };

  nativeBuildInputs = [ gradle makeWrapper ];

  gradleBuildTask = [ "server:downloadWebUI" "server:shadowJar" ];

  mitmCache = gradle.fetchDeps {
    pkg = finalAttrs.finalPackage;
    data = ./deps.json;
  };

  installPhase = ''
    mkdir -p $out/share/suwayomi-server
    cp server/build/Suwayomi-Server-*.jar $out/share/suwayomi-server/
  '';

  meta.sourceProvenance = with lib.sourceTypes; [
    fromSource
    binaryBytecode
  ];
})
