{
  config,
  lib,
  pkgs,
  trivnixLib,
  ...
}:
let
  prefs = config.userPrefs;
  scheme = config.stylixPrefs.theme;
  getColor = trivnixLib.getColor pkgs scheme;

  overrides = ''
    /** OVERRIDES ***/
    user_pref("browser.ctrlTab.sortByRecentlyUsed", true);
    user_pref("places.history.enabled", false);
    user_pref("sidebar.revamp", true);
    user_pref("sidebar.verticalTabs", true);
  '';

  betterFox = pkgs.fetchurl {
    url = "https://raw.githubusercontent.com/yokoffing/Betterfox/refs/heads/main/user.js";
    sha256 = "sha256-ZpWvGPD/nzOrYln+cnm3j/T02zsNHEsI053rEuPhQxQ=";
  };
in
{
  config = lib.mkIf prefs.librewolf.enable {
    home.file = {
      ".librewolf/${config.userInfos.name}/user.js".text =
        builtins.readFile betterFox + " \n" + overrides;

      ".librewolf/${config.userInfos.name}/chrome/userChrome.css".text = ''
        :root {
          --lwt-accent-color: ${getColor "base00"} !important;
          --lwt-text-color: ${getColor "base05"} !important;
          --toolbar-bgcolor: ${getColor "base00"} !important;
          --toolbar-color: ${getColor "base05"} !important;
          --tab-selected-bgcolor: ${getColor "base01"} !important;
        }
      '';
    };

    stylix.targets.librewolf.profileNames = [ config.userInfos.name ];

    programs.librewolf = {
      enable = true;

      profiles.${config.userInfos.name} = {
        isDefault = true;

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
                  params = [ (lib.nameValuePair "q" "{searchTerms}") ];
                }
              ];
            };

            mynixos = {
              name = "MyNixOS";
              urls = [
                {
                  template = "https://mynixos.com/search";
                  definedAliases = [ "@mn" ];
                  params = [ (lib.nameValuePair "q" "{searchTerms}") ];
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
                    (lib.nameValuePair "channel" config.hostInfos.stateVersion)
                    (lib.nameValuePair "query" "{searchTerms}")
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
