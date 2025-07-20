let
  mkHomeConfig = { libExtra, userconfigs, ... }: {
    imports = [
      (libExtra.mkFlakePath /home/common)
      (libExtra.mkFlakePath /home/modules)
    ];

    homeModules = userconfigs.trivaris.homeModules;
  };
in
{

  desktop = mkHomeConfig;
  laptop = mkHomeConfig;
  server = mkHomeConfig;
  wsl = mkHomeConfig;

}
