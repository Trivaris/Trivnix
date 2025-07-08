# Secrets Management

This repository uses **SOPS** with **AGE keys** to manage encrypted secrets. Each host and user has their own key, and the `.sops.yaml` file defines exactly who can decrypt which files

## Directory Layout

```yaml
secrets/
├── .sops.yaml                # Encryption policy
├── hosts/
│   ├── common.yaml           # Shared host secrets
│   ├── desktop.yaml
│   ├── laptop.yaml
│   └── wsl.yaml
└── home/
    └── <username>/
        ├── common.yaml       # Shared user secrets
        ├── desktop.yaml
        ├── laptop.yaml
        └── wsl.yaml
```

## Key Groups

- **host_keys** – one key per machine (e.g. `desktop`, `laptop`, `wsl`)
- **\<username\>_keys** – one key per user‑device (e.g. `alice_laptop`, `bob_desktop`)

These keys are defined once in `.sops.yaml` and reused via YAML anchors.

## How `.sops.yaml` Works

`creation_rules` map file patterns to the key groups allowed to decrypt them. The rules below summarize the intent:

| File Pattern                | Decryption Keys                     | Purpose                          |
|-----------------------------|-------------------------------------|----------------------------------|
| `hosts/common.yaml`         | all `host_keys`                     | Secrets shared by every host     |
| `hosts/{device}.yaml`       | matching `host_key` only            | Host‑specific secrets            |
| `home/<user>/common.yaml`   | all keys for `<user>`               | User secrets shared across hosts |
| `home/<user>/{device}.yaml` | only that `<user>_<device>` key     | Per‑device user secrets          |

This ensures that each machine can only read its own host secrets, while users can only read their own files.

## Expected Secrets

The following secrets are referenced by the Nix modules and should be placed in
the corresponding YAML files.

### Host secrets (`secrets/hosts/*.yaml`)

- `user-passwords/<user>` [common] – hashed passwords for system users. Referenced by `hosts/common/users/*` (in `hosts/common.yaml`).
- `sops-keys/<user>` – the AGE private key for each user. Written to `/home/<user>/.config/sops/age/keys.txt` during activation.
- `ssh-host-key` – host SSH key installed to `/etc/ssh/ssh_host_ed25519_key`.

### User secrets (`secrets/home/<user>/*.yaml`)

- `ssh-user-key.key` – user's private SSH key stored at `/home/<user>/.ssh/id_ed25519`.
- `ssh-user-key.passphrase` – passphrase used by `home/<user>/credentials.nix`.
- `smtp-passwords.{public,private,school}` – mail account passwords (in `<user>/common.yaml`, currently unused).

## Encrypting Secrets

1. Generate age keys for your hosts and user devices.
2. Update `.sops.yaml` with the public keys in the appropriate groups.
3. Place your unencrypted YAML files under `hosts/` or `home/`.
4. Run `sops --encrypt --in-place <file>` to encrypt each file.

After encryption, commit the `.sops.yaml` and the encrypted secrets. Keep your private keys out of version control.

