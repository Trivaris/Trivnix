{
  pkgs,
  inputs,
  lib,
  ...
}:
{
  environment.systemPackages = [ pkgs.home-manager ];
  home-manager = {
    useUserPackages = true;
    backupFileExtension = "${lib.readFile "${pkgs.runCommandNoCC "timestamp" { } "echo -n `date '+%Y%m%d%H%M%S'` > $out"}"}-backup";
    extraSpecialArgs = { inherit inputs; };
  };
}
