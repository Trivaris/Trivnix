{ pkgs, lib, config, inputs, userconfig, ... }:
let
  cfg = config.homeModules.librewolf;
in
with lib;
{

  options.homeModules.librewolf = {
    enable = mkEnableOption ''
      Enable LibreWolf with hardened privacy and security settings.
      Also manages a Betterfox user.js config and extensions via NUR.
    '';
  };

  config = mkIf cfg.enable {
    programs.firefox = {
      enable = true;
      package = pkgs.librewolf;

      profiles.${userconfig.name} = {
        extensions = {
          packages = with pkgs.nur.repos.rycee.firefox-addons; [
            addons.adnauseam
            addons.tab-session-manager
            addons.bitwarden
          ];
        };
        isDefault = true;
        search = {
          engines = {
            brave = {
              name = "Brave";
              urls = [{
                template = "https://search.brave.com/search";
                params = [{ name = "q"; value = "{searchTerms}"; }];
              }];
              default = true;
            };
          };
        };
      };

      policies = {
        DisableTelemetry = true;
        DisableFirefoxStudies = true;
        SanitizeOnShutdown = true;
        ClearOnShutdown = {
          cache = true;
          cookies = true;
          downloads = true;
          formdata = true;
          history = true;
          passwords = false;
          sessions = true;
          siteSettings = false;
          offlineApps = true;
        };

        Cookies.Allow = [
          "https://github.com"
          "https://asuracomic.net"
          "https://www.kenmei.co"
          "https://www.youtube.com"
          "https://www.figma.com"
          "https://f95zone.to"
          "https://www.livechart.me"
          "https://anilist.co"
          "https://www.cloudflare.com"
          "https://auth.mangadex.org"
          "https://www.reddit.com"
          "https://www.google.com"
          "https://vault.trivaris.org"
          "https://accounts.google.com"
          "https://mangadex.org"
        ];
      };
    };

    home.file.".librewolf/user.js".source = inputs.betterfox + "/user.js";
  };
}
