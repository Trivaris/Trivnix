# Secrets Management

This repository uses **SOPS** with **AGE keys** to manage encrypted secrets. Each host and user has their own key, and `.sops.yaml` defines exactly who can decrypt which files.

## Directory Layout

```yaml
secrets/
├── .sops.yaml
├── host/
│   ├── common.yaml
│   ├── desktop.yaml
│   ├── lab.yaml
│   ├── laptop.yaml
│   └── server.yaml
└── home/
    └── <username>/
        ├── common.yaml
        ├── desktop.yaml
        ├── lab.yaml
        ├── laptop.yaml
        └── server.yaml
```

## Key Groups

- **host_keys** – one key per machine (desktop, lab, laptop, server)
- **`<user>_keys`** – one key per user-device (e.g. `trivaris_desktop`, `trivaris_lab`, ...)

## How `.sops.yaml` Works

`creation_rules` map file patterns to the key groups allowed to decrypt them:

| File Pattern                | Decryption Keys                     | Purpose                          |
|-----------------------------|-------------------------------------|----------------------------------|
| `host/common.yaml`          | all `host_keys`                     | Secrets shared by every host     |
| `host/<device>.yaml`        | matching `host_key` only            | Host-specific secrets            |
| `home/<user>/common.yaml`   | all keys for `<user>`               | User secrets shared across hosts |
| `home/<user>/<device>.yaml` | only that `<user>_<device>` key     | Per-device user secrets          |

This ensures that each machine can only read its own host secrets, while users can only read their own files.

## Expected Secrets

`host/common/secrets.nix` and `home/common/secrets.nix` define the secrets that must exist.

### Host secrets

`secrets/host/<configname>.yaml` (per-host files) must include:

- `sops-keys/<user>` – user AGE keys copied to `/home/<user>/.config/sops/age/key.txt`
- `ssh-root-key` – root SSH key stored at `/root/.ssh/id_ed25519`
- `ssh-host-key` – host SSH key stored at `/etc/ssh/ssh_host_ed25519_key` when `hostPrefs.openssh.enable = true`
- `wireguard-client-key` – client private key when `hostPrefs.wireguard.enable = true`

`secrets/host/common.yaml` (shared across hosts) holds:

- `wireguard-preshared-keys/<interface>` – one per interface declared in `inputs.trivnixPrivate.wireguardInterfaces`
- `cloudflare-api-token` and `cloudflare-api-account-token` – required when the reverse proxy module is enabled
- `nextcloud-admin-token` – password for the Nextcloud module
- `suwayomi-webui-password` – password for the Suwayomi module
- `vaultwarden-admin-token` – admin token for Vaultwarden

Add additional entries here as you enable more host modules.

### User secrets

`home/common/secrets.nix` expects the following layout for each user:

- `secrets/home/<user>/<host>.yaml` (per-host file) stores SSH keys
  - `ssh-private-key` when `hostInfos.hardwareKey = false`
  - `ssh-private-key-a` and `ssh-private-key-c` when hardware-backed keys are enabled
- `secrets/home/<user>/common.yaml` (shared across hosts) stores application secrets
  - `email-passwords/<account>` for every account listed in `inputs.trivnixPrivate.emailAccounts.<user>`
  - `email-passwords/<account>-hashed` for accounts served by the mail server module (defaults to `personal-hashed`)
  - `calendar-passwords/<calendar>` for every calendar listed in `inputs.trivnixPrivate.calendarAccounts.<user>`

Provide an entry in `inputs.trivnixPrivate.emailAccounts` and `calendarAccounts` for each user, even if it is an empty attrset; `home/common/secrets.nix` asserts that those attrsets exist.

## Encrypting Secrets

1. Generate AGE keys for your hosts and user devices.
2. Update `.sops.yaml` with the public keys in the appropriate groups (`host_keys`, `<user>_keys`).
3. Place your unencrypted YAML files under `secrets/host/` or `secrets/home/<user>/`.
4. Run `sops --encrypt --in-place <file>` to encrypt each file.

After encryption, commit `.sops.yaml` and the encrypted secrets. Keep your private keys out of version control.
