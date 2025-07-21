let
  mkHomeConfig = { libExtra, userconfigs, ... }: {
    imports = [
      (libExtra.mkFlakePath /home/common)
      (libExtra.mkFlakePath /home/modules)
    ];

    homeConfig = userconfigs.trivaris.homeConfig;
  };
in
{

  desktop = mkHomeConfig;
  laptop = mkHomeConfig;
  server = mkHomeConfig;
  wsl = mkHomeConfig;

}
