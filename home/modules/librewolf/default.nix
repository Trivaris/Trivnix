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

    programs.firefox = {
      enable = true;
      package = pkgs.librewolf;

      profiles."default" = {
        search.engines = import ./search-engines.nix;
        extensions.packages = import ./extensions.nix pkgs;
        settings = {
          "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
        };
      };
      policies = {
        DisableTelemetry = true;
        DisableFirefoxStudies = true;
        Preferences = {
          "cookiebanners.service.mode.privateBrowsing" = 2; # Block cookie banners in private browsing
          "cookiebanners.service.mode" = 2; # Block cookie banners
          "privacy.donottrackheader.enabled" = true;
          "privacy.fingerprintingProtection" = true;
          "privacy.resistFingerprinting" = true;
          "privacy.trackingprotection.emailtracking.enabled" = true;
          "privacy.trackingprotection.enabled" = true;
          "privacy.trackingprotection.fingerprinting.enabled" = true;
          "privacy.trackingprotection.socialtracking.enabled" = true;
        };
        ExtensionSettings = {
          "adnauseam@rednoise.org" = {
            install_url = "https://addons.mozilla.org/firefox/downloads/latest/adnauseam/latest.xpi";
            installation_mode = "force_installed";
          };
          "Tab-Session-Manager@sienori" = {
            install_url = "https://addons.mozilla.org/firefox/downloads/latest/tab-session-manager/latest.xpi";
            installation_mode = "force_installed";
          };
          "keepassxc-browser@keepassxc.org" = {
            install_url = "https://addons.mozilla.org/firefox/downloads/latest/keepassxc-browser/latest.xpi";
            installation_mode = "force_installed";
          };
          "jid0-3GUEt1r69sQNSrca5p8kx9Ezc3U@jetpack.xpi" = {
            install_url = "https://addons.mozilla.org/firefox/downloads/latest/terms-of-service-didnt-read/latest.xpi";
            installation_mode = "force_installed";
          };
        };
      };
    };

  };

}
