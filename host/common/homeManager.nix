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
    backupFileExtension = lib.readFile "${pkgs.runCommandNoCC "timestamp" { }
      "echo -n $(date '+%d-%m-%Y-%H-%M-%S')-backup > $out"
    }";
    extraSpecialArgs = { inherit inputs; };
  };
}
