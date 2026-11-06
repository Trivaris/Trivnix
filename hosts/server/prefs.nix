{
  flake.nixosModules.server =
    {
      pkgs,
      lib,
      config,
      ...
    }:
    {
      services.minecraft-server = {
        enable = true;
        package = pkgs.minecraft-server-fabric;
        eula = true;
        openFirewall = true;
      };

      networking.firewall.checkReversePath = "loose";
      networking.firewall.trustedInterfaces = [ "wg0" ];

      hostPrefs = {
        headless = true;
        openssh = {
          enable = true;
          ports = [ 222 ];
        };

        wireguard =
          let
            allPeers = config.private.wgPeers.hosts // config.private.wgPeers.guests;
            localPeer = allPeers.${config.hostInfos.configname};
            otherPeers = lib.filterAttrs (name: _: name != config.hostInfos.configname) allPeers;
          in
          {
            enable = true;
            interfaceName = "wg0";
            address = "10.0.0.${toString localPeer.id}/32";
            peers = lib.mapAttrsToList (name: peer: {
              publicKey = lib.removeSuffix "\n" (builtins.readFile peer.key);
              allowedIPs = [ "10.0.0.${toString peer.id}/32" ];
              endpoint = peer.endpoint;
            }) otherPeers;
          };

        reverseProxy = {
          enable = true;
          email = "cloudflare@tripple.lurdane.de";
          zone = "trivaris.org";
          dumbPipes = {
            enable = true;
            upstreams = {
              homelab.address = "10.0.0.10";
              git-homelab = {
                port = 22;
                address = "10.0.0.10";
              };
              syncthing-homelab = {
                port = 22000;
                address = "10.0.0.10";
              };
            };
            pipes = {
              "home.trivaris.org" = "homelab";
              "jelly.trivaris.org" = "homelab";
              "slskd.trivaris.org" = "homelab";
              "git.trivaris.org" = "homelab";
              "navi.trivaris.org" = "homelab";
              "jellyapi.trivaris.org" = "homelab";
              "beszel.trivaris.org" = "homelab";
              "seerr.trivaris.org" = "homelab";
              "immich.trivaris.org" = "homelab";
              "vault.trivaris.org" = "homelab";
              "sync.trivaris.org" = "homelab";
              # "coolify.trivaris.org" = "homelab";
              # "soketi.trivaris.org" = "homelab";
              "librechat.trivaris.org" = "homelab";
            };
            portForwards = {
              forgejo-ssh = {
                listenPort = 22;
                upstream = "git-homelab";
                enableTCP = true;
              };
              syncthing-sync = {
                listenPort = 22000;
                upstream = "syncthing-homelab";
                enableTCP = true;
                enableUDP = true;
              };
            };
          };
        };

        tandoor = {
          enable = true;
          reverseProxy = {
            enable = true;
            domain = "tandoor.trivaris.org";
            port = 8099;
          };
        };

        cfddns = {
          enable = true;
          reverseProxy = {
            enable = true;
            domain = "cfddns.trivaris.org";
            port = 8892;
          };
        };

        collabora = {
          enable = true;
          nextcloudFQDNs = [ "cloud.joneit.net" ];
          reverseProxy = {
            enable = true;
            domain = "collabora.trivaris.org";
            port = 9980;
          };
        };

        # vaultwarden = {
        #   enable = true;
        #   # sendMails = true;
        #   reverseProxy = {
        #     enable = true;
        #     domain = "vault.trivaris.org";
        #     port = 8891;
        #   };
        # };

        paperless = {
          enable = true;
          reverseProxy = {
            enable = true;
            domain = "paperless.trivaris.org";
            port = 28981;
          };
        };

        # syncthing = {
        #   enable = true;
        #   reverseProxy = {
        #     enable = true;
        #     domain = "syncthing.trivaris.org";
        #     port = 8384;
        #   };
        # };

        # mailserver = {
        #   enable = true;
        #   domain = "trivaris.org";
        #   extraDomains = [ "mail" ];
        #   providerName = "Trivaris Mail";
        #   accounts."mail@trivaris.org" = {
        #     hashedPassword = "$2b$05$7p74qoLRa2R09CJwkkL8MeKqM3oOfC4rgb0R.K1jQlO2TWpj9E3Fe";
        #     aliases = [
        #       "@mail.trivaris.org"
        #       "@trivaris.org"
        #     ];
        #   };
        # };

        # piHole = {
        #   enable = true;
        #   reverseProxy = {
        #     enable = true;
        #     domain = "pihole.trivaris.org";
        #     port = 8895;
        #   };
        #   lists = [
        #     # ad-blocker
        #     {
        #       enabled = true;
        #       type = "block";
        #       url = "https://cdn.jsdelivr.net/gh/hagezi/dns-blocklists@latest/adblock/pro.txt";
        #       description = "URL Shortener";
        #     }
        #   ];
        # };

        # matrix = {
        #   enable = true;
        #   reverseProxy = {
        #     enable = true;
        #     domain = "matrix.trivaris.org";
        #     port = 6167;
        #   };
        # };

        # affine = {
        #   enable = true;
        #   sendMails = true;
        #   reverseProxy = {
        #     enable = true;
        #     domain = "affine.trivaris.org";
        #     port = 3010;
        #   };
        # };

        # n8n = {
        #   enable = true;
        #   reverseProxy = {
        #     enable = true;
        #     domain = "n8n.trivaris.org";
        #     port = 5678;
        #   };
        # };

        # evolution = {
        #   enable = true;
        #   reverseProxy = {
        #     enable = true;
        #     domain = "evolution.trivaris.org";
        #     port = 8079;
        #   };
        # };
      };
    };
}
