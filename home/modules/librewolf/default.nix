{ pkgs, lib, config, inputs, ... }:
let
  cfg = config.homeModules.librewolf;
  addons = pkgs.nur.repos.rycee.firefox-addons;
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
    home.packages = [
      addons.adnauseam
      addons.tab-session-manager
      addons.bitwarden
    ];

    programs.firefox = {
      enable = true;
      package = pkgs.librewolf;

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
          offlineApps = true;
          passwords = false;
          sessions = true;
          siteSettings = false;
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
