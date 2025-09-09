# Trivnix-Private Contract

Provide private, non-committable data as a flake that exports a few well-known attributes. Trivnix reads these from `inputs.trivnix-private`.

Your internal layout is up to you — only the outputs matter.

## Required Outputs

Expose the following top-level attributes from your flake outputs:

- `emailAccounts`: attrset of Home Manager email account definitions
- `calendarAccounts`: attrset of Thunderbird calendar definitions
- `wireguardInterfaces`: attrset of builders for wg-quick interfaces

### `emailAccounts`

Type: attrset where each key is an account name and each value matches the Home Manager `accounts.email.accounts.<name>` schema.

- Trivnix augments each account with:
  - `passwordCommand = "cat ${config.sops.secrets.\"email-passwords/<name>\".path}"`
  - Thunderbird profile settings if Thunderbird is enabled for the user
- Provide the usual fields for the HM email module (examples):
  - `address`, `realName`, `userName`, `primary`
  - `imap = { host; port; tls; }`
  - `smtp = { host; port; tls; }`
  - Any other options accepted by Home Manager

Minimal example

```nix
emailAccounts = {
  personal = {
    address = "you@example.com";
    realName = "You";
    userName = "you";
    primary = true;
    imap = { host = "imap.example.com"; port = 993; tls = true; };
    smtp = { host = "smtp.example.com"; port = 587; tls = true; };
  };
};
```

Secrets

- Provide `email-passwords/<account>` in the user’s SOPS file (`secrets/home/<user>/common.yaml`).

### `calendarAccounts`

Type: attrset where each key is a calendar name and each value is an attrset with:

- `uuid` (string): stable unique ID used as `calendar.registry.<uuid>`
- `type` (string): e.g. `"caldav"`
- `uri` (string): full CalDAV URL
- `username` (string)
- `color` (string): e.g. `"#d3869b"`

Trivnix maps these into Thunderbird profile settings.

Example

```nix
calendarAccounts = {
  work = {
    uuid = "0deaff7b-53a9-4c0d-8b8b-2aefbd9c2f10";
    type = "caldav";
    uri = "https://cal.example.com/dav/you/calendar";
    username = "you";
    color = "#5e81ac";
  };
};
```

Secrets

- Provide `calendar-passwords/<account>` in the user’s SOPS file (`secrets/home/<user>/common.yaml`).

### `wireguardInterfaces`

Type: attrset where each key is an interface name (e.g., `wg1`) and each value is a function that accepts a small context (provided by Trivnix) and returns a `networking.wg-quick.interfaces.<name>` attrset.

The function is called as `interface { privateKeyFile; presharedKeyFile; ipAddr; }` where:

- `privateKeyFile` is the SOPS secret path for the client private key
- `presharedKeyFile` is the SOPS secret path for the peer preshared key
- `ipAddr` is the host’s `infos.ip`

Example

```nix
wireguardInterfaces = {
  wg1 = { privateKeyFile, presharedKeyFile, ipAddr, ... }: {
    address = [ "10.0.0.2/24" ];
    dns = [ "1.1.1.1" ];
    privateKeyFile = privateKeyFile;
    peers = [
      {
        publicKey = "<server-pubkey>";
        presharedKeyFile = presharedKeyFile;
        endpoint = "vpn.example.com:51820";
        allowedIPs = [ "0.0.0.0/0" "::/0" ];
        persistentKeepalive = 25;
      }
    ];
  };
};
```

Secrets

- Host-level SOPS file (`secrets/host/<configname>.yaml`) must include:
  - `wireguard-client-key` (private key)
  - `wireguard-preshared-keys/<interface>` (per-interface preshared key)

## Wiring Your Private Flake

You can override this repo’s `trivnix-private` input at build time:

```bash
sudo nixos-rebuild switch \
  --flake github:trivaris/trivnix#<configname> \
  --override-input trivnix-private github:<you>/<your-private-repo>
```

Or edit `flake.nix` locally to point `trivnix-private` to your repository.

## Access

Because this repository is private, ensure your machine has SSH access to it (SSH key loaded/agent forwarding). If access fails, rebuilds that reference `trivnix-private` will error.
