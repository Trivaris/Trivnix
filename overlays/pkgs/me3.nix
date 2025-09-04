pkgs:
let
  me3 = {
    pname = "me3";
    version = "v0.7.0";

    src = pkgs.fetchurl {
      url = "https://github.com/garyttierney/me3/releases/download/${me3.version}/me3-linux-amd64.tar.gz";
      sha256 = "sha256-88WYgv82MShq35VgWaeBcmGJr6z5ktmlX73FcELRtXg=";
    };

    sourceRoot = ".";
    nativeBuildInputs = [
      pkgs.autoPatchelfHook
      pkgs.makeWrapper
    ];
    buildInputs = builtins.attrValues {
      inherit (pkgs.xorg) libX11;
      inherit (pkgs.gcc.cc) lib;
      inherit (pkgs)
        glibc
        libGL
        zlib
        ;
    };

    installPhase = ''
      runHook preInstall
      mkdir -p $out/share/me3
      cp -r . $out/share/me3

      mkdir -p $out/bin

      # wrap with steam-run so Steam/Proton/sniper find GL & friends
      makeWrapper ${pkgs.steam-run}/bin/steam-run $out/bin/me3 \
        --add-flags "$out/share/me3/bin/me3"

      # expose the helper launchers via steam-run as well
      for f in launch-*.sh; do
        makeWrapper ${pkgs.steam-run}/bin/steam-run $out/bin/$f \
          --add-flags "$out/share/me3/$f"
      done
      runHook postInstall
    '';

    meta = {
      description = "A framework for modding and instrumenting games.";
      homepage = "https://https://github.com/garyttierney/me3";
      license = pkgs.lib.licenses.mit;
    };
  };
in
pkgs.stdenv.mkDerivation me3
