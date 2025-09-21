# Option Reference

This page condenses every option exported by modules under `home/common`, `home/modules`, `host/common`, and `host/modules`. Use it as a quick lookup while editing `trivnixConfigs` or debugging evaluations. Types mirror the corresponding `lib.types.*` declarations and defaults come from the module definitions.

## Home Manager (`userPrefs.*`)

### Email Accounts
| Option | Type | Default | Description |
| --- | --- | --- | --- |
| `userPrefs.email.enable` | bool | `false` | Enables the SOPS-backed email module so accounts are imported from `trivnixPrivate`. Turns on address provisioning plus application integration. |
| `userPrefs.email.exclude` | list of account ids | `[]` | Account identifiers to skip when building mailboxes. Use it to omit secrets from `inputs.trivnixPrivate.emailAccounts.<user>`. |
| `userPrefs.email.generateAccountsFile` | bool | `true` | Writes `~/.config/mailaccounts.json` with the filtered account metadata. Disable when another tool manages the JSON file. |
| `userPrefs.email.enableThunderbirdIntegration` | bool | `true` | Automatically wires Thunderbird profiles with credentials from SOPS. Set to `false` if you maintain Thunderbird preferences manually. |

### CLI Toolkit
| Option | Type | Default | Description |
| --- | --- | --- | --- |
| `userPrefs.cli.enabled` | list of CLI module names | `[]` | CLI submodules to enable from `home/modules/cli`. Each entry merges extra configuration for that tool. |
| `userPrefs.cli.replaceDefaults` | list of CLI module names | auto-detected replacements | Names of CLI modules that should replace stock binaries (e.g. `eza` for `ls`). Defaults to every module that declares itself a drop-in replacement. |

### GUI Programs
| Option | Type | Default | Description |
| --- | --- | --- | --- |
| `userPrefs.gui` | list of GUI module names | `[]` | Desktop applications to install via `home/modules/gui`. Modules add packages and per-app tweaks. |
| `userPrefs.lutris.enable` | bool | `false` | Installs Lutris into the user profile. Enable on machines that run game launchers outside Steam. |
| `userPrefs.vscodium.enableLsp` | bool | `false` | Adds Nix language tooling (nixd, nixfmt) and configures VSCodium for LSP integration. Toggle when you want IDE support for `.nix` files. |
| `userPrefs.vscodium.fixServer` | bool | `false` | Patches the VSCodium remote server to use the packaged Node.js binary. Useful when remote editing fails because node is missing. |
| `userPrefs.jetbrainsIDEs` | enum ( `pkgs.jetbrains` modules ) | `[]` | Each entry simply adds the package to the profile. |

### Browsers
| Option | Type | Default | Description |
| --- | --- | --- | --- |
| `userPrefs.browsers` | list of browser module names | `[]` | Browser choices from `home/common/browsers`. Each entry simply adds the package to the profile. |
| `userPrefs.librewolf.betterfox` | bool | `false` | Merge Betterfox's hardened defaults into LibreWolf's `user.js`. Requires the `betterfox` flake input. |
| `userPrefs.librewolf.clearOnShutdown` | bool | `false` | Clears browsing data whenever LibreWolf closes. Ideal for shared or kiosk-like environments. |
| `userPrefs.librewolf.allowedCookies` | list of origins | `[]` | Cookie allowlist used when `clearOnShutdown` is true. Provide full origins (scheme + host) that should retain cookies. |

### Shell, Terminal, Launcher
| Option | Type | Default | Description |
| --- | --- | --- | --- |
| `userPrefs.shell` | enum (`home/common/shell` modules) | — | Primary login shell module to activate (e.g. `"fish"`). Selects the interpreter and associated tweaks. |
| `userPrefs.terminalEmulator` | null or enum (`home/common/terminalEmulator` modules) | `null` | Preferred terminal emulator module. Set to a module name like `"alacritty"` or leave `null` to skip installing one. |
| `userPrefs.appLauncher` | null or enum (`home/common/appLauncher` modules) | `null` | Desktop launcher module to enable (such as `"rofi"`). `null` keeps the system default. |

### Desktop Environments
| Option | Type | Default | Description |
| --- | --- | --- | --- |
| `userPrefs.desktopEnvironment` | null or enum (`home/common/desktopEnvironment` modules) | `null` | Desktop environment module to configure for the user session. Leave `null` to inherit whatever the system provides. |
| `userPrefs.hyprland.wallpapers` | list of paths | `[]` | Wallpaper image paths for Hyprland. The module copies each file into place and rotates through them. |

### Miscellaneous User Options
| Option | Type | Default | Description |
| --- | --- | --- | --- |
| `userPrefs.enableRandomStuff` | bool | `false` | Installs a curated bundle of miscellaneous desktop utilities (KDE tools, media apps, etc.). Toggle when you want the extras. |
| `userPrefs.git.email` | string | — | Email address written to the global Git config as `user.email`. Match your forge account to keep commit attribution intact. |
| `userPrefs.git.name` | string | `userInfos.name` | User Name written to the global Git config as `user.name`. Match your forge account to keep commit attribution intact. |
| `userPrefs.git.enableSigning` | bool | `false` | Enable commit and tag signing with the key defined in secrets |

## Stylix Theme Options (`userPrefs.stylix.*` / `hostPrefs.stylix.*`)
| Option | Type | Default | Description |
| --- | --- | --- | --- |
| `*.stylix.darkmode` | bool | `false` | Enables the dark Stylix colour palette for the profile. Switch it on to render all assets with dark variants. |
| `*.stylix.colorscheme` | string | — | Base16 colour scheme key (without `.yaml`) looked up in `pkgs.base16-schemes`. Controls the global palette. |
| `*.stylix.cursorPackage` | string | — | Nixpkgs attribute name for the desired cursor theme package (e.g. `"catppuccin-cursors"`). |
| `*.stylix.cursorName` | string | — | Internal cursor theme name exposed by the package. Must match a theme provided by the package. |
| `*.stylix.cursorSize` | int | `24` | Pixel size applied to the cursor for both X11 and Wayland sessions. |
| `*.stylix.nerdfont` | string | — | Base name of the Nerd Font family used across monospace, serif, and sans-serif roles. |

## Home Manager Internal Vars (`config.vars.*`)
| Option | Type | Default | Description |
| --- | --- | --- | --- |
| `config.vars.defaultReplacementModules` | list of CLI module names | `[]` | Collected list of CLI modules that mark themselves as shell command replacements. Used to populate `userPrefs.cli.replaceDefaults`. |
| `config.vars.filteredEmailAccounts` | attrset | derived from secrets | Email account definitions after applying `userPrefs.email.exclude`. Downstream modules (SOPS, Thunderbird) reuse this filtered set. |
| `config.vars.desktopEnvironmentBinary` | null or string | `null` | Launch command written by desktop-environment modules for greetd autologin. Hyprland sets this to its binary. |
| `config.vars.appLauncherFlags` | string | `""` | Extra command-line flags appended by app-launcher modules. Hyprland keybinds consult this value. |

## NixOS Host (`hostPrefs.*`)

### Base System & Desktop
| Option | Type | Default | Description |
| --- | --- | --- | --- |
| `hostPrefs.services` | list of service module names | `[]` | Optional service modules from `host/common/services` to activate (e.g. `"bluetooth"`, `"printing"`). |
| `hostPrefs.displayManager` | null or enum (`host/common/displayManager` modules) | `null` | Display manager module to enable (`"gdm"`, `"sddm"`, `"autologin"`). Leave `null` for a TTY setup. |
| `hostPrefs.bluetooth.enable` | bool | `false` | Enables kernel Bluetooth support and the Blueman applet. Required for pairing controllers or audio devices. |
| `hostPrefs.printing.enable` | bool | `false` | Activates CUPS with the Samsung unified driver. Toggle when printers should be managed locally. |
| `hostPrefs.steam.enable` | bool | `false` | Installs Steam with Proton tooling. Enable on gaming-oriented hosts. |
| `hostPrefs.kdeConnect.enable` | bool | `false` | Adds KDE Connect and opens the firewall ranges for device pairing. |

### Locale & Identity
| Option | Type | Default | Description |
| --- | --- | --- | --- |
| `hostPrefs.nixos.oldProfileDeleteInterval` | string | `"3d"` | Age threshold passed to `nix-collect-garbage --delete-older-than`. Controls when stale system profiles are pruned. |
| `hostPrefs.nixos.mainUser` | string | first user from `allUserInfos` | Primary user treated as the host owner. Used by modules such as autologin and service defaults. |
| `hostPrefs.language.keyMap` | string | `"us"` | Console and XKB keyboard layout (e.g. `"us"`, `"de"`). Applied to virtual terminals and the X server. |
| `hostPrefs.language.locale` | string | `"en_US"` | Default locale governing interface language and formatting. |
| `hostPrefs.language.charset` | string | `"UTF-8"` | Character encoding appended to locale definitions. |
| `hostPrefs.language.units` | string | `"de_DE"` | Locale used for measurement units and LC_* overrides. |

### Auto Upgrade Service
| Option | Type | Default | Description |
| --- | --- | --- | --- |
| `hostPrefs.autoUpgrade.enable` | bool | `false` | Turns on the git-driven auto-upgrade service that periodically rebuilds the host. |
| `hostPrefs.autoUpgrade.repoUrl` | string | `"git@github.com:Trivaris/trivnix.git"` | Remote flake URL cloned before each upgrade cycle. Point it at your configuration repository. |
| `hostPrefs.autoUpgrade.branch` | string | `"main"` | Branch checked out by the upgrade service. Changes on this branch trigger rebuilds. |
| `hostPrefs.autoUpgrade.workdir` | string | `"/var/lib/trivnix"` | Directory where the flake is cloned and reused across runs. |
| `hostPrefs.autoUpgrade.interval` | string | `"1min"` | Systemd timer interval (OnBootSec / OnUnitInactiveSec) controlling upgrade frequency. |

### Security & Remote Access
| Option | Type | Default | Description |
| --- | --- | --- | --- |
| `hostPrefs.openssh.enable` | bool | `false` | Enables the OpenSSH server and opens the firewall. Required for incoming SSH access. |
| `hostPrefs.openssh.ports` | list of ports | `[22]` | TCP ports the SSH daemon listens on. Make sure matching firewall rules exist. |
| `hostPrefs.wireguard.enable` | bool | `false` | Configures WireGuard client interfaces from `trivnixPrivate`. Opens UDP/51820 and generates wg-quick profiles. |
| `hostPrefs.wireguard.enableServer` | bool | `false` | Placeholder flag for future server support. No configuration is emitted yet, so leave disabled unless implementing server mode. |

### Reverse Proxy Core
| Option | Type | Default | Description |
| --- | --- | --- | --- |
| `hostPrefs.reverseProxy.enable` | bool | `false` | Activates the shared Nginx reverse proxy for HTTP services. When enabled, participating modules register virtual hosts. |
| `hostPrefs.reverseProxy.enableDDClient` | bool | `false` | Enables ddclient to update dynamic DNS records for the configured zone. |
| `hostPrefs.reverseProxy.email` | string | — | Email address supplied to ACME/Let's Encrypt for certificate issuance and renewal notices. |
| `hostPrefs.reverseProxy.zone` | string | — | Cloudflare (or other provider) DNS zone managed by ddclient. |
| `hostPrefs.reverseProxy.port` | port | `443` | External HTTPS port exposed by Nginx. Ensure your firewall/NAT forwards it. |
| `hostPrefs.reverseProxy.extraDomains` | list of strings | `[]` | Additional FQDNs to include in ddclient updates beyond the registered services. |
| `hostPrefs.reverseProxy.ddnsTime` | null or string | `null` | Systemd OnCalendar schedule for ddclient runs (e.g. `"daily"`, `"04:00"`). `null` disables the timer. |

### Reverse Proxy Service Submodule
The following fields exist under `hostPrefs.<service>.reverseProxy` for every service module that exposes HTTP(S) endpoints.

| Field | Type | Default | Description |
| --- | --- | --- | --- |
| `enable` | bool | `false` | Opts the service into the shared reverse proxy and ACME handling. |
| `port` | int | module default (e.g. 47989 for Sunshine) | Internal service port used by the upstream application. |
| `domain` | string | `""` | Fully-qualified domain name served by Nginx for this application. |
| `externalPort` | null or int | `null` | Optional external port for the public listener when it differs from 443. |
| `ipAddress` | string | `"127.0.0.1"` | Upstream bind address. Use `"0.0.0.0"` to listen on all interfaces. |

### Application Modules

#### Sunshine
| Option | Type | Default | Description |
| --- | --- | --- | --- |
| `hostPrefs.sunshine.enable` | bool | `false` | Enables the Sunshine game-streaming daemon and registers it with the reverse proxy. |
| `hostPrefs.sunshine.hostMac` | string | — | MAC address targeted by Sunshine's wake-on-LAN packets so Moonlight clients can power on the host. |
| `hostPrefs.sunshine.reverseProxy` | submodule | port defaults to `47989` | Standard reverse-proxy configuration for Sunshine. See the submodule table above for field meanings. |

#### Code Server
| Option | Type | Default | Description |
| --- | --- | --- | --- |
| `hostPrefs.codeServer.enable` | bool | `false` | Launches code-server (VS Code in the browser) behind the reverse proxy. |
| `hostPrefs.codeServer.reverseProxy` | submodule | port defaults to `8888` | Reverse-proxy settings for code-server. |

#### Suwayomi
| Option | Type | Default | Description |
| --- | --- | --- | --- |
| `hostPrefs.suwayomi.enable` | bool | `false` | Deploys the Suwayomi (Tachidesk) manga server. |
| `hostPrefs.suwayomi.reverseProxy` | submodule | port defaults to `8890` | Reverse-proxy settings for Suwayomi. |

#### Vaultwarden
| Option | Type | Default | Description |
| --- | --- | --- | --- |
| `hostPrefs.vaultwarden.enable` | bool | `false` | Runs the Vaultwarden password manager backend. |
| `hostPrefs.vaultwarden.reverseProxy` | submodule | port defaults to `8891` | Reverse-proxy settings for Vaultwarden. |

#### Forgejo
| Option | Type | Default | Description |
| --- | --- | --- | --- |
| `hostPrefs.forgejo.enable` | bool | `false` | Hosts a Forgejo git instance. |
| `hostPrefs.forgejo.reverseProxy` | submodule | port defaults to `3000` | Reverse-proxy settings for Forgejo. |

#### Nextcloud
| Option | Type | Default | Description |
| --- | --- | --- | --- |
| `hostPrefs.nextcloud.enable` | bool | `false` | Deploys a Nextcloud instance with PostgreSQL and Redis backing services. |
| `hostPrefs.nextcloud.reverseProxy` | submodule | port defaults to `8889` | Reverse-proxy settings for Nextcloud. |

#### Minecraft Server
| Option | Type | Default | Description |
| --- | --- | --- | --- |
| `hostPrefs.minecraftServer.enable` | bool | `false` | Provisions a modded Fabric-based Minecraft server with LazyMC support. |
| `hostPrefs.minecraftServer.reverseProxy` | submodule | port defaults to `25565` | Reverse-proxy settings for the Minecraft server and RCON exposure. |
| `hostPrefs.minecraftServer.modpack` | enum (`pkgs.modpacks` keys) | — | Modpack to deploy on the server. Must match an attribute under `pkgs.modpacks`. |
| `hostPrefs.minecraftServer.serverIcon` | path | — | Path to the 64×64 PNG used as the server icon. Copied into the world directory. |

#### Mailserver
| Option | Type | Default | Description |
| --- | --- | --- | --- |
| `hostPrefs.mailserver.enable` | bool | `false` | Turns on the mailserver stack (Postfix, Dovecot, automx). |
| `hostPrefs.mailserver.enablePop3` | bool | `false` | Enables POP3 alongside IMAP for legacy clients. |
| `hostPrefs.mailserver.enableIpV6` | bool | `false` | Configures IPv6 addresses and firewall rules for mail services. |
| `hostPrefs.mailserver.ipV6Address` | string | — | IPv6 address assigned to the interface serving mail. |
| `hostPrefs.mailserver.ipV6Interface` | string | — | Network interface name carrying the mail IPv6 address. |
| `hostPrefs.mailserver.domain` | string | — | Primary mail FQDN (also used as the server's MX). |
| `hostPrefs.mailserver.baseDomain` | string | — | Root domain you control for MX/SRV records and ACME issuance. |
| `hostPrefs.mailserver.providerName` | string | — | Human-friendly provider name advertised via AutoMX responses. |

