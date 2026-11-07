{
  flake.nixosModules.system-core =
    { pkgs, ... }:
    {
      environment.systemPackages = [ pkgs.home-manager ];
      home-manager = {
        useGlobalPkgs = true;
        useUserPackages = true;
      };
    };
}
