## Regenerating a `sops-nix` Configuration

trivaris will be used as placeholder for your username

Absolutely — here's an expanded version of your section that keeps it concise but provides a bit more clarity and flow for readers who may be unfamiliar with the mechanics of SOPS or how Nix flakes handle secrets:

### How This Flake Uses Keys

The `secrets.yaml` file contains all passwords and sensitive data used in this flake-based NixOS configuration. It is encrypted using [SOPS](https://github.com/getsops/sops) with Age encryption.

There are two key types involved:

| Name | Algorithm | Path | Purpose |
|------|-----------|------|---------|
| **Master key** | Age | `/var/lib/sops-nix/master.age` | Used **during installation** to decrypt secrets before the host key exists |
| **Host key**   | OpenSSH → Age | `/etc/ssh/ssh_host_ed25519_key` | Used **after installation** for subsequent decrypts on that host |

During the installation process:

* The flake decrypts `secrets.yaml` using the **master key**.
* It extracts host-specific values such as SSH private keys and initial user passwords.
* These secrets are written to the appropriate locations (e.g., `/etc/ssh`).

After installation:

* The system can use its **host key** to re-decrypt the secrets in future rebuilds or updates — without needing the master key.

This approach allows secure provisioning while ensuring each host remains self-contained and capable of decrypting its own secrets independently.

> ⚠️ **Important:** *Host SSH keys* (one per machine) are **not** the same as *user SSH keys* (one per user). Only **host keys** participate in SOPS encryption/decryption.


### Convert or Generate Keys
---

#### 1. Master Age Private Key

Generate using `nix-shell`:

```bash
age-keygen -o master.age && age-keygen -y master.age > master.age.pub
```

Keep this file safe — ideally stored securely in a password manager like KeePass.

---

#### 2. Host SSH Public Keys (converted to Age)

Generate or use existing ones, then convert with `ssh-to-age`:

```bash
ssh-keygen -t ed25519 -f ./ssh_host_ed25519_key -N "" && \
nix-shell -p ssh-to-age --run "ssh-to-age < ./ssh_host_ed25519_key.pub | tee ./ssh_host_ed25519_key.age.pub"
```

Keep these files safe — ideally stored securely in a password manager like KeePass.


---


## Regenerating Encrypted Secrets

### 1. Prepare public keys

You should now have keys like these.

```yaml
# MASTER KEY (must be AGE format) [if generated, it should be in master.age.pub]
MASTER_PUB="age1g24xxtf3hxldudfedy74gtzg25ygrzjzd5zr9g0m3pw8vegxydeqvs5xxm"

# HOSTS (converted from SSH keys) [if generated, it should be in ssh_host_ed25519_key.age.pub]
WSL_PUB="age1z0zu80qx8xrgkjm4hmwevmz8acmye3wstef5mx9lsfd3xsz09a8szkxjg7"
LAPTOP_PUB="age1evl3qa9amaznmv37a85kjha9jxgd6kn2j5jkqj0nvvc6ggfgxd4qhvflnw"
DESKTOP_PUB="age1tfz3wsnre7yn6k43gsasx6tw2rf7h27gda7rdvu9l3wqxr4hca6qpy2j4v"
```
> These are my public keys. Replace them with your own from now on, unless you want me to be able to decrypt your secrets.

---

### 2. Write `.sops.yaml`

```yaml
keys:
  - &master  age1g24xxtf3hxldudfedy74gtzg25ygrzjzd5zr9g0m3pw8vegxydeqvs5xxm
  - &wsl     age1z0zu80qx8xrgkjm4hmwevmz8acmye3wstef5mx9lsfd3xsz09a8szkxjg7
  - &desktop age1tfz3wsnre7yn6k43gsasx6tw2rf7h27gda7rdvu9l3wqxr4hca6qpy2j4v
  - &laptop  age1evl3qa9amaznmv37a85kjha9jxgd6kn2j5jkqj0nvvc6ggfgxd4qhvflnw

creation_rules:
  - path_regex: secrets.yaml$
    key_groups:
      - age: [ *master, *desktop, *laptop, *wsl ]
```

---

### 3. Write `secrets.yaml`

If starting from scratch:

```yaml
user-passwords:
  trivaris: "someHashedPassword"
  root:     "someOtherHashedPassword"
smtp-passwords:
  public:  "smtp-password-one"
  private: "smtp-password-two"
  school:  "smtp-password-three"

ssh-private-keys:
  trivaris:
    wsl:      |
        -----BEGIN OPENSSH PRIVATE KEY-----
        multiple lines of ssh key...
        -----END OPENSSH PRIVATE KEY-----
    laptop:   |
        -----BEGIN OPENSSH PRIVATE KEY-----
        multiple lines of ssh key...
        -----END OPENSSH PRIVATE KEY-----
    desktop:  |
        -----BEGIN OPENSSH PRIVATE KEY-----
        multiple lines of ssh key...
        -----END OPENSSH PRIVATE KEY-----
  hosts:
    wsl:      |
        -----BEGIN OPENSSH PRIVATE KEY-----
        multiple lines of ssh key...
        -----END OPENSSH PRIVATE KEY-----
    laptop:   |
        -----BEGIN OPENSSH PRIVATE KEY-----
        multiple lines of ssh key...
        -----END OPENSSH PRIVATE KEY-----
    desktop:  |
        -----BEGIN OPENSSH PRIVATE KEY-----
        multiple lines of ssh key...
        -----END OPENSSH PRIVATE KEY-----
```

---

### 4. Encrypt the file

```bash
sops --encrypt --in-place secrets.yaml
```

Now all machines — and the master key — can decrypt the file.

---

### 5. Confirm recipients

```bash
grep recipient secrets.yaml
```

You should see 4 `age1...` entries, depending on if you changed the amount of hosts.

---

### 6. Cleanup

Commit the encrypted secrets:

```bash
git add resources/secrets.yaml resources/.sops.yaml
git commit -m "chore: Regenerate encrypted secrets for all hosts + master key"
```
> 👉 Only commit **encrypted** files. Keep raw keys (`master.age`, `ssh_host_ed25519_key.age` or `ssh_host_ed25519_key`) out of version control.