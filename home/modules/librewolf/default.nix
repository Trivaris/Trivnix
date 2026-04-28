{
  config,
  osConfig,
  lib,
  pkgs,
  ...
}:
let
  librewolfPrefs = config.userPrefs.librewolf;
  theme = osConfig.themingPrefs.scheme;

  overrides = ''
    /** OVERRIDES ***/
    user_pref("browser.ctrlTab.sortByRecentlyUsed", true);
    user_pref("places.history.enabled", false);
    user_pref("sidebar.revamp", true);
    user_pref("sidebar.verticalTabs", true);
  '';

  betterFox = pkgs.fetchurl {
    url = "https://raw.githubusercontent.com/yokoffing/Betterfox/a9b4b8803aebd3a87492f0936db5a3c8513ae522/user.js";
    sha256 = "sha256-Xo3NJ8BL/Px0neuYagxZpdKc3qRA0M3q95fKMNu8ruE=";
  };

  smoothFox = pkgs.fetchurl {
    url = "https://raw.githubusercontent.com/yokoffing/Betterfox/a9b4b8803aebd3a87492f0936db5a3c8513ae522/Smoothfox.js";
    sha256 = "sha256-S1zDXctpV1jNlV9DCua4fYMHfR7T34V3gQi780ShFpk=";
  };
in
{
  config = lib.mkIf librewolfPrefs.enable {
    home.file = {
      ".librewolf/${config.userInfos.name}/search.json.mozlz4".force = lib.mkForce true;

      ".librewolf/${config.userInfos.name}/user.js".text =
        builtins.readFile betterFox + " \n" +
        builtins.readFile smoothFox + " \n" +
        overrides;

      ".librewolf/${config.userInfos.name}/chrome/userChrome.css".text = ''
        :root {
          --lwt-accent-color: ${theme.base00} !important;
          --lwt-text-color: ${theme.base05} !important;
          --toolbar-bgcolor: ${theme.base00} !important;
          --toolbar-color: ${theme.base05} !important;
          --tab-selected-bgcolor: ${theme.base01} !important;
        }
      '';
    };

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
              definedAliases = [ "@mn" ];
              urls = [
                {
                  template = "https://mynixos.com/search";
                  params = [ (lib.nameValuePair "q" "{searchTerms}") ];
                }
              ];
            };

            nixos-search = {
              name = "Nix Packages";
              definedAliases = [ "@np" ];
              urls = [
                {
                  template = "https://search.nixos.org/packages";
                  params = [
                    (lib.nameValuePair "channel" osConfig.hostInfos.stateVersion)
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
        Cookies.Allow = librewolfPrefs.allowedCookies;

        SanitizeOnShutdown = {
          cache = true;
          cookies = true;
          downloads = true;
          formdata = true;
          history = true;
          passwords = true;
          sessions = true;
          siteSettings = true;
          offlineApps = true;
        };
      };
    };
  };
}
