{
  pkgs,
  lib,
  config,
  ...
}:
let 
  cfg = config.modules;
in 
with lib;
{

  options.modules.librewolf = mkEnableOption "librewolf";

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