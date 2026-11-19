{ inputs, ... }:
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
      colorSchemes = inputs.nix-colors.colorSchemes;

      spicetifyOptions = {
        options = {
          package = lib.mkOption {
            type = lib.types.attrs;
            default = pkgs.spicetify-packages.themes.catppuccin;
            defaultText = lib.literalExpression "pkgs.spicetify-packages.themes.catppuccin";
            description = "The Spicetify theme to use.";
          };

          scheme = lib.mkOption {
            type = lib.types.nonEmptyStr;
            default = if hostTheming.darkMode then "mocha" else "latte";
            defaultText = lib.literalExpression ''if config.host.theming.darkMode then "mocha" else "latte"'';
            example = "macchiato";
            description = "Color scheme variant of the selected Spicetify theme.";
          };
        };
      };

      themeOverrideOptions = {
        options = {
          spicetify = lib.mkOption {
            type = lib.types.submodule spicetifyOptions;
            default = { };
            description = "Spicetify specific theme configuration.";
          };

          kitty = lib.mkOption {
            type = lib.types.nullOr lib.types.path;
            default = null;
            example = lib.literalExpression ''"''${pkgs.kitty-themes}/share/kitty-themes/themes/Catppuccin-Mocha.conf"'';
            description = ''
              Path to a Kitty theme file to include instead of the theme
              generated from the base16 scheme. `null` uses the generated theme.
            '';
          };
        };
      };

      fontOptions = {
        options = {
          package = lib.mkPackageOption pkgs "font" {
            default = [
              "nerd-fonts"
              "roboto-mono"
            ];
            example = [
              "nerd-fonts"
              "jetbrains-mono"
            ];
          };

          monoName = lib.mkOption {
            type = lib.types.nonEmptyStr;
            default = "RobotoMono Nerd Font Mono";
            example = "JetBrainsMono Nerd Font Mono";
            description = "Font family name used for monospace text (terminals, code editors).";
          };

          propoName = lib.mkOption {
            type = lib.types.nonEmptyStr;
            default = "RobotoMono Nerd Font Propo";
            example = "JetBrainsMono Nerd Font Propo";
            description = "Font family name used for proportional text (UI elements, web browsing).";
          };

          extraFonts = lib.mkOption {
            type = lib.types.listOf lib.types.package;
            default = [ ];
            example = lib.literalExpression "[ pkgs.noto-fonts-color-emoji ]";
            description = "Additional font packages to install system-wide.";
          };
        };
      };
    in
    {
      options.host = {
        preferences = {
          oldProfileDeleteInterval = lib.mkOption {
            type = lib.types.strMatching "^[0-9]+d$";
            default = "14d";
            example = "30d";
            description = ''
              Maximum age of system profiles before garbage collection removes them.
              This value is passed to `nix-collect-garbage --delete-older-than`.
            '';
          };

          headless = lib.mkEnableOption "headless operation without graphical features";
        };

        theming = {
          darkMode = lib.mkEnableOption "dark mode" // {
            default = true;
          };

          schemeName = lib.mkOption {
            type = lib.types.enum (builtins.attrNames colorSchemes);
            default = if hostTheming.darkMode then "catppuccin-mocha" else "catppuccin-latte";
            defaultText = lib.literalExpression ''
              if config.host.theming.darkMode then "catppuccin-mocha" else "catppuccin-latte"
            '';
            example = "gruvbox-dark-medium";
            description = ''
              Name of the base16 color scheme used for system theming.
              Must be one of the schemes shipped by `nix-colors`.
            '';
          };

          scheme = lib.mkOption {
            type = lib.types.attrsOf (lib.types.strMatching "^#[a-fA-F0-9]{6}$");
            default = lib.mapAttrs (_: color: "#${color}") colorSchemes.${hostTheming.schemeName}.palette;
            defaultText = lib.literalExpression ''
              lib.mapAttrs (_: color: "#''${color}")
                inputs.nix-colors.colorSchemes.''${config.host.theming.schemeName}.palette
            '';
            example = {
              base00 = "#1e1e2e";
              base05 = "#cdd6f4";
            };
            description = ''
              The base16 palette (`base00` to `base0F`) as `#rrggbb` hex colors.
              Derived from `schemeName` by default; set it directly to use a custom palette.
            '';
          };

          themeOverrides = lib.mkOption {
            type = lib.types.submodule themeOverrideOptions;
            default = { };
            description = ''
              Application-specific theme overrides that deviate from the global base16 scheme.
              Useful when an application has a dedicated theme package (like Catppuccin) that
              looks better than a procedurally generated base16 template.
            '';
          };

          font = lib.mkOption {
            type = lib.types.submodule fontOptions;
            default = { };
            example = lib.literalExpression ''
              {
                package = pkgs.nerd-fonts.jetbrains-mono;
                monoName = "JetBrainsMono Nerd Font Mono";
                propoName = "JetBrainsMono Nerd Font Propo";
              }
            '';
            description = "Global font configuration applied across the system and GUI applications.";
          };
        };
      };
    };
}
