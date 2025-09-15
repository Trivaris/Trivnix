{
  pkgs,
  inputs,
  lib,
  ...
}:
let
  inherit (lib) readFile;
in
{
  environment.systemPackages = [ pkgs.home-manager ];
  home-manager = {
    useUserPackages = true;
    backupFileExtension = readFile "${pkgs.runCommandNoCC "timestamp" { }
      "echo -n $(date '+%d-%m-%Y-%H-%M-%S')-backup > $out"
    }";
    extraSpecialArgs = { inherit inputs; };
  };
}
