{ ... }:
{
  flake.nixosModules.common-theming =

    { pkgs, ... }:
    {
      programs.dconf.enable = true;

      themingPrefs = {
        darkmode = true;
        # schemeName = "catppuccin-frappe";
        scheme = {
          base00 = "#1a1626";
          base01 = "#251f38";
          base02 = "#382e56";
          base03 = "#57497d";
          base04 = "#8b83bc";
          base05 = "#c2bde6";
          base06 = "#e2e0f2";
          base07 = "#f7f6fc";
          base08 = "#ff3366";
          base09 = "#ff5e36";
          base0A = "#ffb84d";
          base0B = "#2ee6a8";
          base0C = "#00e5ff";
          base0D = "#3688ff";
          base0E = "#b84df7";
          base0F = "#ff3399";
        };

        themeOverrides = {
          # kitty = "${pkgs.kitty-themes}/share/kitty-themes/themes/Catppuccin-Mocha.conf";
          # spicetify = {
          #   package = pkgs.spicePkgs.themes.catppuccin;
          #   scheme = "mocha";
          # };
        };

        font = {
          package = pkgs.nerd-fonts.adwaita-mono;
          monoName = "AdwaitaMono Nerd Font Mono";
          propoName = "AdwaitaMono Nerd Font Propo";
          extraFonts = [
            pkgs.noto-fonts
          ];
        };
      };
    };
}
