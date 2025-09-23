{
  config,
  lib,
  pkgs,
  inputs,
  trivnixLib,
  userInfos,
  ...
}:
let
  inherit (lib) mkIf nameValuePair;
  prefs = config.userPrefs;
  scheme = config.stylix.base16Scheme;
  getColor = trivnixLib.getColor { inherit pkgs scheme; };

  overrides = ''

    /** OVERRIDES ***/
    user_pref("browser.ctrlTab.sortByRecentlyUsed", true);
    user_pref("places.history.enabled", false);
    user_pref("sidebar.revamp", true);
    user_pref("sidebar.verticalTabs", true);
  '';
in
{
  options.userPrefs.librewolf = import ./options.nix lib;

  config = mkIf (builtins.elem "librewolf" prefs.browsers) {
    assertions = import ./assertions.nix { inherit prefs inputs; };

    programs.librewolf = {
      enable = true;

      profiles.${userInfos.name} = {
        isDefault = true;

        extensions = {
          force = true;
          packages = builtins.attrValues {
            inherit (pkgs.nur.repos.rycee.firefox-addons)
              adnauseam
              tab-session-manager
              bitwarden
              youtube-shorts-block
              ;
          };
        };

        search = {
          default = "brave";
          order = [ "brave" ];

          engines = {
            brave = {
              name = "Brave";
              urls = [
                {
                  template = "https://search.brave.com/search";
                  params = [ (nameValuePair "q" "{searchTerms}") ];
                }
              ];
            };
          };
        };
      };

      policies = {
        DisableTelemetry = true;
        DisableFirefoxStudies = true;
        SanitizeOnShutdown = mkIf prefs.librewolf.clearOnShutdown true;
        Cookies.Allow = prefs.librewolf.allowedCookies;

        ClearOnShutdown = mkIf prefs.librewolf.clearOnShutdown {
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
      };
    };

    stylix.targets.librewolf.enable = false;

    home.file = {
      ".librewolf/${userInfos.name}/user.js".text =
        let
          betterfoxJs =
            if prefs.librewolf.betterfox then builtins.readFile "${inputs.betterfox}/user.js" else "";
        in
        betterfoxJs + overrides;

      ".librewolf/${userInfos.name}/chrome/userChrome.css".text = ''
        :root {
          --lwt-accent-color: ${getColor "base00"} !important;
          --lwt-text-color: ${getColor "base05"} !important;
          --toolbar-bgcolor: ${getColor "base00"} !important;
          --toolbar-color: ${getColor "base05"} !important;
          --tab-selected-bgcolor: ${getColor "base01"} !important;
        }
      '';
    };
  };
}
