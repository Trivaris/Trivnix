{
  flake.homeModules.apps-librewolf =
    {
      config,
      osConfig,
      lib,
      pkgs,
      ...
    }:
    let
      librewolfPreferences = config.user.preferences.librewolf;
      # scheme = osConfig.host.theming.scheme;

      overrides = ''
        /** OVERRIDES ***/
        user_pref("browser.ctrlTab.sortByRecentlyUsed", true);
        user_pref("places.history.enabled", false);
        user_pref("sidebar.revamp", true);
        user_pref("sidebar.verticalTabs", true);
      '';

      betterfox = pkgs.fetchurl {
        url = "https://raw.githubusercontent.com/yokoffing/Betterfox/7558fdc9c5aa4483d3010584fd0c2ea9f7e47c5e/user.js";
        sha256 = "sha256-prmJFuPkfVsAN23oP1apQZHpqFoVrpQrWasqgTAha3w=";
      };

      smoothfox = pkgs.fetchurl {
        url = "https://raw.githubusercontent.com/yokoffing/Betterfox/7558fdc9c5aa4483d3010584fd0c2ea9f7e47c5e/Smoothfox.js";
        sha256 = "sha256-h3eZp18vYr8DCB21LhkoGH67Yrx3xkpSOMuWcbo1w+A=";
      };
    in
    {
      config = lib.mkIf librewolfPreferences.enable {
        home.sessionVariables.MOZ_ENABLE_WAYLAND = 1;

        home.file = {
          ".librewolf/${config.home.username}/search.json.mozlz4".force = lib.mkForce true;

          ".librewolf/${config.home.username}/user.js".text =
            builtins.readFile betterfox + " \n" + builtins.readFile smoothfox + " \n" + overrides;

          # ".librewolf/${config.home.username}/chrome/userChrome.css".text = ''
          #   :root {
          #     --lwt-accent-color: ${theme.base00} !important;
          #     --lwt-text-color: ${theme.base05} !important;
          #     --toolbar-bgcolor: ${theme.base00} !important;
          #     --toolbar-color: ${theme.base05} !important;
          #     --tab-selected-bgcolor: ${theme.base01} !important;
          #   }
          # '';
          # ".librewolf/${config.home.username}/chrome/userContent.css".text = ''
          #   body {
          #     background: transparent !important;
          #   }
          # '';
        };

        programs.librewolf = {
          enable = true;
          package = pkgs.librewolf-bin;

          profiles.${config.home.username} = {
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
                        (lib.nameValuePair "channel" osConfig.host.info.stateVersion)
                        (lib.nameValuePair "query" "{searchTerms}")
                      ];
                    }
                  ];
                };
              };
            };
          };

          # settings."toolkit.legacyUserProfileCustomizations.stylesheets" = true;

          policies = {
            DisableTelemetry = true;
            DisableFirefoxStudies = true;
            Cookies.Allow = librewolfPreferences.allowedCookies;

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
    };
}
