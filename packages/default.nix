{
  perSystem = { pkgs, ... }: {
    packages = {
      # qml-language-server = qml-language-server.packages."${system}".default;
      cfddns-middleware = pkgs.callPackage ./_cfddns-middleware.nix { };
      jtegranx = pkgs.callPackage ./_jtegranx { };
      minecraft-server-fabric = pkgs.callPackage ./_minecraft-server-fabric.nix { };
      quartz = pkgs.callPackage ./_quartz.nix { };
    };
  };
}
