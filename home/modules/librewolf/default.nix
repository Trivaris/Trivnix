{
  config,
  hostInfos,
  inputs,
  isNixos,
  lib,
  osConfig,
  pkgs,
  trivnixLib,
  userInfos,
  ...
}:
let
  inherit (lib) mkIf nameValuePair;
  prefs = config.userPrefs;

  scheme = (if isNixos then osConfig else config).stylix.base16Scheme;
  getColor = trivnixLib.getColor scheme;

  overrides = ''

    /** OVERRIDES ***/
    user_pref("browser.ctrlTab.sortByRecentlyUsed", true);
    user_pref("places.history.enabled", false);
    user_pref("sidebar.revamp", true);
    user_pref("sidebar.verticalTabs", true);
  '';
in
{
  config = mkIf prefs.librewolf.enable {
    stylix.targets.librewolf.enable = false;

    home.file = {
      ".librewolf/${userInfos.name}/user.js".text =
        (builtins.readFile "${inputs.betterfox}/user.js") + overrides;

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
          order = [
            "brave"
            "mynixos"
            "nixos-search"
          ];

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

            mynixos = {
              name = "MyNixOS";
              urls = [
                {
                  template = "https://mynixos.com/search";
                  definedAliases = [ "@mn" ];
                  params = [ (nameValuePair "q" "{searchTerms}") ];
                }
              ];
            };

            nixos-search = {
              name = "Nix Packages";
              urls = [
                {
                  template = "https://search.nixos.org/packages";
                  definedAliases = [ "@np" ];
                  params = [
                    (nameValuePair "channel" hostInfos.stateVersion)
                    (nameValuePair "query" "{searchTerms}")
                  ];
                }
              ];
            };
          };
        };
      };

      policies = {
        DisableTelemetry = true;
        DisableFirefoxStudies = true;
        SanitizeOnShutdown = true;
        Cookies.Allow = prefs.librewolf.allowedCookies;

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
      };
    };
  };
}
