{
  perSystem = { pkgs, ... }: {
    packages = {
      # qml-language-server = qml-language-server.packages."${system}".default;
      cfddns-middleware = pkgs.callPackage ./cfddns-middleware.nix { };
      jtegranx = pkgs.callPackage ./jtegranx { };
      minecraft-server-fabric = pkgs.callPackage ./minecraft-server-fabric.nix { };
      quartz = pkgs.callPackage ./quartz.nix { };
    };
  };
}
