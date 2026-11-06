{
  flake.nixosModules.server =
    { pkgs, ... }:
    let
      background = pkgs.fetchurl {
        url = "https://raw.githubusercontent.com/Trivaris/TrivnixConfigs/44c7c084c770aa79dcdc614dcf6c0a3699004f50/resources/wallpapers/nix3.jpg";
        hash = "sha256-XHSB1HNqMlm5fJncw83tXNhDEZzQg0MAwdZ9mbtYu9k=";
      };
      favicon = pkgs.fetchurl {
        url = "https://raw.githubusercontent.com/Trivaris/TrivnixConfigs/44c7c084c770aa79dcdc614dcf6c0a3699004f50/resources/icons/nixowos.svg";
        hash = "sha256-7e5fX1QZy7s2GITJZIqB7qocgOWRtXuyVGlW+dYHjyU=";
      };
    in
    {
      hostPrefs.homepage = {
        enable = true;
        reverseProxy = {
          enable = true;
          domain = "dash.trivaris.org";
          port = 8082;
        };
      };

      services.homepage-dashboard = {

        settings = {
          favicon = favicon;
          color = "gray";

          layout = [
            {
              Glances = {
                header = false;
                style = "row";
                columns = 4;
              };
            }
          ];

          background = {
            image = background;
            blur = "sm";
            saturate = 100;
            brightness = 100;
            opacity = 50;
          };
        };

        services = [
          {
            Glances =
              let
                port = "61208";
              in
              [
                {
                  Info = {
                    widget = {
                      type = "glances";
                      url = "http://localhost:${port}";
                      metric = "info";
                      version = 4;
                    };
                  };
                }
                {
                  Processes = {
                    widget = {
                      type = "glances";
                      url = "http://localhost:${port}";
                      metric = "process";
                      version = 4;
                    };
                  };
                }
                {
                  Disk = {
                    widget = {
                      type = "glances";
                      url = "http://localhost:${port}";
                      metric = "disk:sda3";
                      version = 4;
                    };
                  };
                }
              ];
          }
          {
            Services = [
              {
                Forgejo = {
                  description = "Personal Git Forge";
                  href = "https://git.trivaris.org";
                  icon = "gitea.svg";
                };
              }
              {
                Vaultwarden = {
                  description = "Personal Password Manager";
                  href = "https://vault.trivaris.org";
                  icon = "vaultwarden.svg";
                };
              }
            ];
          }
        ];

        widgets = [
          {
            openmeteo = {
              label = "Hamburg";
              latitude = "53.583076";
              longitude = "10.082634";
              timezone = "Europe/Berlin";
              units = "metric";
              cache = "5";
            };
          }
          {
            datetime = {
              locale = "de";
              format = {
                dateStyle = "long";
                timeStyle = "long";
              };
            };
          }
          {
            search = {
              provider = "brave";
              showSearchSuggestions = "true";
              suggestionUrl = "https://search.brave.com/api/suggest?q=";
              target = "_blank";

            };
          }
        ];
      };
    };
}
