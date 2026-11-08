{
  flake.nixosModules.system-core =
    {
      lib,
      pkgs,
      config,
      ...
    }:
    let
      hostTheming = config.host.theming;
    in
    {
      options.host.theming = {
        # mkEnableOption automatically generates the description: "Whether to enable Dark Mode."
        darkMode = lib.mkEnableOption "Dark Mode";

        schemeName = lib.mkOption {
          type = lib.types.str;
          default = "catppuccin-frappe";
          description = ''
            The base16 color scheme name to use for system theming. 
            This must match a valid yaml file name in the `base16-schemes` package.
          '';
        };

        scheme = lib.mkOption {
          type = lib.types.attrsOf (lib.types.strMatching "^#[a-fA-F0-9]{6}$");
          description = ''
            The evaluated base16 palette generated from the specified `schemeName`. 
            This is automatically derived using `yq` and the `base16-schemes` package, 
            providing a set of hex colors (e.g., base00, base01) to be used across configurations.
          '';
          default = builtins.fromJSON (
            builtins.readFile (
              pkgs.runCommand "load-scheme" {
                nativeBuildInputs = [
                  pkgs.yq
                  pkgs.base16-schemes
                ];
              } "yq '.palette' ${pkgs.base16-schemes}/share/themes/${config.host.theming.schemeName}.yaml > $out"
            )
          );
        };

        themeOverrides = lib.mkOption {
          description = ''
            Application-specific theme overrides that deviate from the global base16 scheme.
            Useful when an application has a dedicated theme package (like Catppuccin) that 
            looks better than a procedurally generated base16 template.
          '';
          type = lib.types.nullOr (
            lib.types.submodule {
              options = {
                spicetify = lib.mkOption {
                  description = "Spicetify specific theme configuration.";
                  type = lib.types.nullOr (
                    lib.types.submodule {
                      options = {
                        package = lib.mkOption {
                          type = lib.types.nullOr lib.types.attrs;
                          default = pkgs.spicetify-packages.themes.catppuccin;
                          description = "The Spicetify theme package to use.";
                        };
                        scheme = lib.mkOption {
                          type = lib.types.str;
                          default = "mocha";
                          description = "The specific color scheme variant (e.g., mocha, macchiato) for the selected Spicetify theme.";
                        };
                      };
                    }
                  );
                  example = {
                    package = pkgs.spicetify-packages.themes.catppuccin;
                    scheme = "mocha";
                  };
                  default = null;
                };

                kitty = lib.mkOption {
                  type = lib.types.nullOr lib.types.str;
                  description = "Absolute path to the Kitty terminal theme configuration file.";
                  example = "\${pkgs.kitty-themes}/share/kitty-themes/themes/Catppuccin-Mocha.conf";
                  default = null;
                };
              };
            }
          );
          default = null;
        };

        font = lib.mkOption {
          description = "Global font configuration applied across the system and GUI applications.";
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
                description = "The exact font family name to use for monospace text (terminals, code editors).";
              };

              propoName = lib.mkOption {
                type = lib.types.str;
                default = "RobotoMono Nerd Font Propo";
                description = "The exact font family name to use for proportional text (UI elements, web browsing).";
              };

              extraFonts = lib.mkOption {
                type = lib.types.listOf lib.types.package;
                default = [ ];
                description = "A list of additional font packages to install system-wide.";
                example = lib.literalExpression "[ pkgs.noto-fonts-emoji ]";
              };
            };
          };
          default = {
            package = pkgs.nerd-fonts.jetbrains-mono;
          };
        };
      };

      config = {
        qt.enable = true;

        fonts = {
          enableDefaultPackages = true;
          packages = [ hostTheming.font.package ] ++ hostTheming.font.extraFonts;
          fontconfig = {
            enable = true;
            useEmbeddedBitmaps = true;
            defaultFonts = {
              emoji = [ "Noto Color Emoji" ];
              monospace = [ hostTheming.font.monoName ];
              sansSerif = [ hostTheming.font.propoName ];
              serif = [ hostTheming.font.propoName ];
            };
          };
        };
      };
    };
}
