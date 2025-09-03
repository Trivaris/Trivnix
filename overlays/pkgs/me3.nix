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
    nativeBuildInputs = [ pkgs.autoPatchelfHook ];
    buildInputs = [ pkgs.glibc pkgs.gcc.cc.lib ];

    installPhase = ''
      mkdir -p $out/share/me3
      cp -r * $out/share/me3

      mkdir -p $out/bin
      ln -s $out/share/me3/bin/me3 $out/bin/me3

      for f in launch-*.sh; do
        ln -s $out/share/me3/$f $out/bin/$f
      done
    '';

    meta = {
      description = "A framework for modding and instrumenting games.";
      homepage = "https://https://github.com/garyttierney/me3";
      license = pkgs.lib.licenses.mit;
    };
  };
in
pkgs.stdenv.mkDerivation me3