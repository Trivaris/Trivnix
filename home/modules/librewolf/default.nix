{ pkgs, lib, config, inputs, userconfig, ... }:
let
  cfg = config.homeConfig.librewolf;
in
with lib;
{

  options.homeConfig.librewolf = {
    enable = mkEnableOption ''
      Enable LibreWolf with hardened privacy and security settings.
      Also manages a Betterfox user.js config and extensions via NUR.
    '';
  };

  config = mkIf cfg.enable {
    programs.librewolf = {
      enable = true;

      profiles.${userconfig.name} = {
        isDefault = true;

        extensions = {
          packages = with pkgs.nur.repos.rycee.firefox-addons; [
            adnauseam
            tab-session-manager
            bitwarden
          ];
        };
        
        search = {
          default = "brave";
          order = [ "brave" ];
          engines = {
            brave = {
              name = "Brave";
              urls = [{
                template = "https://search.brave.com/search";
                params = [{ name = "q"; value = "{searchTerms}"; }];
              }];
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

    home.file.".librewolf/${userconfig.name}/user.js".source = inputs.betterfox + "/user.js";
  };
}
