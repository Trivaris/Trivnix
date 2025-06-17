{
  pkgs,
  lib,
  config,
  ...
}:
let 
  cfg = config.homeModules;
in 
with lib;
{

  options.homeModules.librewolf = mkEnableOption "librewolf";

  config = mkIf cfg.librewolf {

    programs.librewolf = {
      enable = true;
      profiles.default = {
        settings = import ./user.js.nix;
        search.engines = import ./search-engines.nix;
        extensions.packages = import ./extensions.nix pkgs;
      };
    };

  };

}