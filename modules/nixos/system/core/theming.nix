{
  flake.nixosModules.system-core =
    {
      lib,
      pkgs,
      config,
      ...
    }:
    let
      prefs = config.themingPrefs;
    in
    {
      options.themingPrefs = {
        darkmode = lib.mkEnableOption "Enable Dark Mode";
        schemeName = lib.mkOption {
          type = lib.types.str;
          default = "catppuccin-frappe";
        };

        scheme = lib.mkOption {
          type = lib.types.attrsOf (lib.types.strMatching "^#[a-f|A-F|0-9]{6,6}$");
          default = builtins.fromJSON (
            builtins.readFile (
              pkgs.runCommand "load-scheme" {
                nativeBuildInputs = [
                  pkgs.yq
                  pkgs.base16-schemes
                ];
              } "yq '.palette' ${pkgs.base16-schemes}/share/themes/${prefs.schemeName}.yaml > $out"
            )
          );
        };

        themeOverrides = lib.mkOption {
          type = lib.types.nullOr (
            lib.types.submodule {
              options = {
                spicetify = lib.mkOption {
                  type = lib.types.nullOr (
                    lib.types.submodule {
                      options = {
                        package = lib.mkOption {
                          type = lib.types.nullOr lib.types.attrs;
                          default = pkgs.spicePkgs.themes.catppuccin;
                        };
                        scheme = lib.mkOption {
                          type = lib.types.str;
                          default = "mocha";
                        };
                      };
                    }
                  );
                  example = {
                    package = pkgs.spicePkgs.themes.catppuccin;
                    scheme = "mocha";
                  };
                  default = null;
                };
                kitty = lib.mkOption {
                  type = lib.types.nullOr lib.types.str;
                  example = "${pkgs.kitty-themes}/share/kitty-themes/themes/Catppuccin-Mocha.conf";
                  default = null;
                };
              };
            }
          );
          default = null;
        };

        font = lib.mkOption {
          type = lib.types.submodule {
            options = {
              package = lib.mkPackageOption pkgs "Font" {
                default = [
                  "nerd-fonts"
                  "roboto-mono"
                ];
              };
              monoName = lib.mkOption {
                type = lib.types.str;
                default = "RobotoMono Nerd Font Mono";
              };
              propoName = lib.mkOption {
                type = lib.types.str;
                default = "RobotoMono Nerd Font Propo";
              };
              extraFonts = lib.mkOption {
                type = lib.types.listOf lib.types.package;
                default = [ ];
              };
            };
          };
          default = {
            package = pkgs.nerd-fonts.jetbrains-mono;
            name = "JetBrains Mono";
          };
        };
      };
    };
}
