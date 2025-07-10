{ inputs, pkgs }:
let
  version = inputs.suwayomi-server-src.ref or "";
  revision = inputs.suwayomi-server-src.rev;

in
{
#  suwayomi-server = pkgs.suwayomi-server.overrideAttrs (old: {
#    inherit version revision;
#    src = pkgs.fetchurl {
#      url = "https://github.com/Suwayomi/Suwayomi-Server/releases/download/v${version}/Suwayomi-Server-v${version}-r${toString revision}.jar";
#      hash = "sha256-1lg6b2bvh0mfic2i9r4708n4q42074s4mbbmc0xzsh691m51zr9b";
#    };
#  });
}