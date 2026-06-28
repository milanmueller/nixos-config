# backpfeifengesicht Setup Guide

Hardware: AMD Ryzen 7500F · Nvidia GTX 1660 Ti · x86_64

---

## 1. Boot the NixOS installer

Download the latest NixOS ISO (graphical or minimal) and boot from USB.

---

## 2. Partition and format disks

A typical single-disk layout with EFI:

```bash
# Partition (adjust /dev/nvme0n1 to your disk)
parted /dev/nvme0n1 -- mklabel gpt
parted /dev/nvme0n1 -- mkpart ESP fat32 1MB 512MB
parted /dev/nvme0n1 -- set 1 esp on
parted /dev/nvme0n1 -- mkpart primary 512MB 100%

# Format
mkfs.fat -F 32 -n boot /dev/nvme0n1p1
mkfs.ext4 -L nixos /dev/nvme0n1p2
# Optional: LUKS encryption before mkfs.ext4
#   cryptsetup luksFormat /dev/nvme0n1p2
#   cryptsetup open /dev/nvme0n1p2 enc
#   mkfs.ext4 -L nixos /dev/mapper/enc

# Mount
mount /dev/disk/by-label/nixos /mnt
mkdir -p /mnt/boot
mount /dev/disk/by-label/boot /mnt/boot
```

---

## 3. Generate the hardware configuration

```bash
nixos-generate-config --root /mnt
```

Copy the generated file into this repo, replacing the placeholder:

```bash
# From your existing machine (after cloning the repo to /mnt):
cp /mnt/etc/nixos/hardware-configuration.nix \
   /mnt/home/milan/nixos-config/hosts/backpfeifengesicht/hardware-configuration.nix
```

---

## 4. Clone the nixos-config repo

```bash
mkdir -p /mnt/home/milan
git clone https://github.com/milanmueller/nixos-config.git \
    /mnt/home/milan/nixos-config
```

---

## 5. Generate Milan's SSH key on the new machine

This key is what sops-nix uses at runtime to decrypt secrets
(`sops.age.sshKeyPaths = ["/home/milan/.ssh/id_ed25519"]`).

```bash
# Run this on the new machine (or in the installer chroot)
mkdir -p /mnt/home/milan/.ssh
ssh-keygen -t ed25519 -C "milan_backpfeifengesicht" \
           -f /mnt/home/milan/.ssh/id_ed25519
```

---

## 6. Derive the age key and add it to the secrets repo

**On the new machine**, convert the SSH public key to an age key:

```bash
nix-shell -p ssh-to-age --run \
  "ssh-to-age < /mnt/home/milan/.ssh/id_ed25519.pub"
```

This prints something like:
```
age1xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
```

**Switch to an existing machine** (red-miso or any other that can already decrypt secrets) and open the secrets repo:

```bash
cd ~/nixos-secrets
```

Add the new age key to `.sops.yaml`:

```yaml
keys:
  # ... existing keys ...
  - &milan_backpfeifengesicht age1xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx  # ← add this

creation_rules:
  - path_regex: secrets\.yaml$
    key_groups:
    - age:
      # ... existing entries ...
      - *milan_backpfeifengesicht   # ← add this
```

Re-encrypt `secrets.yaml` so the new key can decrypt it:

```bash
sops updatekeys secrets.yaml
```

Commit and push the secrets repo:

```bash
git add .sops.yaml secrets.yaml
git commit -m "Add backpfeifengesicht age key"
git push
```

---

## 7. Update the secrets flake input in nixos-config

On the existing machine, inside `~/nixos-config`:

```bash
nix flake update secrets
git add flake.lock
git commit -m "Update secrets flake input for backpfeifengesicht"
git push
```

---

## 8. Initial NixOS install

Back on the new machine, pull the updated repo and install:

```bash
# Make sure hardware-configuration.nix is in place (step 3)
cd /mnt/home/milan/nixos-config

# Install
nixos-install --flake .#backpfeifengesicht --root /mnt
```

Set the root password when prompted. Set Milan's password afterwards:

```bash
nixos-enter --root /mnt
passwd milan
exit
```

Reboot:

```bash
reboot
```

---

## 9. Post-boot: fix file ownership

After first boot, SSH key ownership needs to be correct:

```bash
chown -R milan:users /home/milan/.ssh
chmod 700 /home/milan/.ssh
chmod 600 /home/milan/.ssh/id_ed25519
```

---

## 10. Add the public key to authorized_keys in nixos-config

So you can SSH into this machine from other hosts, add the new public key
to `modules/defaults.nix` (or a host-specific override):

```nix
users.users.milan.openssh.authorizedKeys.keys = [
  "ssh-ed25519 AAAAC3N..."  # existing development key
  "ssh-ed25519 <backpfeifengesicht public key>"
];
```

---

## 11. Final rebuild

```bash
cd ~/nixos-config
git pull
sudo nixos-rebuild switch --flake .#backpfeifengesicht
```

---

## Troubleshooting

**SOPS decryption fails at boot:**
The age key derived from `/home/milan/.ssh/id_ed25519` must match an entry
in `.sops.yaml`. Re-check step 5–6 if secrets cannot be decrypted.

**Nvidia driver issues:**
The config uses `nvidiaPackages.stable` with `open = false` (required for
Turing/GTX 16xx). If the screen is blank after boot, try adding
`boot.kernelParams = [ "nomodeset" ]` temporarily to reach a console.

**`nixos-install` can't fetch the secrets input:**
The installer needs SSH access to the private secrets repo. Either:
- Copy your `~/.ssh` keys into `/root/.ssh` in the installer environment, or
- Pass `--option access-tokens github.com=<token>` if using HTTPS.
