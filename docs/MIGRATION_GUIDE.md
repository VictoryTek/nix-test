# BlueBuild/bootc to NixOS Translation Guide

This guide helps you understand how your current vex-htpc concepts map to NixOS.

## Architecture Comparison

### BlueBuild/bootc (Your Current Setup)
```
Base Image (silverblue-main)
    ↓
+ Module recipes (files, scripts, dnf packages)
    ↓
+ Flatpaks
    ↓
+ GNOME extensions & gschema overrides
    ↓
= Custom Container Image
    ↓
Rebase system to image
```

### NixOS (Your New Setup)
```
flake.nix (declares dependencies)
    ↓
configuration.nix (system packages & services)
    ↓
home.nix (user config & flatpaks)
    ↓
= Nix derivations
    ↓
Build & activate system
```

## Concept Mapping

| BlueBuild Concept | NixOS Equivalent | Location |
|------------------|------------------|----------|
| `recipe.yml` | `flake.nix` | Root directory |
| `base-image` | `nixpkgs` input | flake.nix |
| `modules.type: files` | `environment.etc` or `home.file` | configuration.nix / home.nix |
| `modules.type: dnf` | `environment.systemPackages` | configuration.nix |
| `modules.type: default-flatpaks` | `services.flatpak.packages` | home.nix |
| `modules.type: gnome-extensions` | `gnomeExtensions.*` | configuration.nix |
| `modules.type: gschema-overrides` | `dconf.settings` | home.nix |
| `modules.type: scripts` | `system.activationScripts` | configuration.nix |
| `rpm-ostree rebase` | `nixos-rebuild switch` | Command line |
| Container image tag | Flake lock hash | flake.lock |
| GitHub Container Registry | GitHub repository | Git |

## File Comparisons

### BlueBuild: dnf.yml
```yaml
type: rpm-ostree
repos:
  - https://example.com/repo.repo
install:
  - firefox
  - vim
  - starship
```

### NixOS: configuration.nix
```nix
environment.systemPackages = with pkgs; [
  firefox
  vim
  starship
];
```

---

### BlueBuild: default-flatpaks.yml
```yaml
type: default-flatpaks
install:
  - com.brave.Browser
  - com.bitwarden.desktop
```

### NixOS: home.nix
```nix
services.flatpak.packages = [
  "com.brave.Browser"
  "com.bitwarden.desktop"
];
```

---

### BlueBuild: gschema-overrides
```ini
[org.gnome.desktop.interface]
color-scheme='prefer-dark'
icon-theme='kora'
```

### NixOS: home.nix
```nix
dconf.settings."org/gnome/desktop/interface" = {
  color-scheme = "prefer-dark";
  icon-theme = "kora";
};
```

---

### BlueBuild: files.yml
```yaml
type: files
files:
  - source: files/system/etc/hostname
    destination: /etc/hostname
```

### NixOS: configuration.nix
```nix
networking.hostName = "vex-htpc";
# Or for custom files:
environment.etc."custom-file" = {
  text = ''
    file contents here
  '';
};
```

## Workflow Comparison

### Making Changes

**BlueBuild:**
1. Edit recipe/module YAML files
2. Push to GitHub
3. GitHub Actions builds new image
4. Wait for build (5-15 minutes)
5. `rpm-ostree rebase` to new image
6. Reboot

**NixOS:**
1. Edit .nix configuration files
2. `nixos-rebuild switch --flake .` (builds locally, 1-5 min)
3. Changes active immediately (no reboot needed*)
4. Commit and push to GitHub

*Most changes don't need reboot, but kernel/bootloader changes do

### Updating

**BlueBuild:**
```bash
# Update to latest image
sudo rpm-ostree upgrade
# Or rebase explicitly
sudo rpm-ostree rebase ostree-image-signed:docker://ghcr.io/victorytek/vex-htpc:latest
```

**NixOS:**
```bash
# Update flake inputs (like updating base image)
nix flake update
# Rebuild with updates
sudo nixos-rebuild switch --flake .#vex-htpc
```

### Rollback

**BlueBuild:**
```bash
# Boot into previous deployment from GRUB menu
# Or via command:
rpm-ostree rollback
```

**NixOS:**
```bash
# Boot into previous generation from bootloader
# Or via command:
sudo nixos-rebuild switch --rollback
```

## Key Differences

### 1. Build Location
- **BlueBuild**: Builds on GitHub Actions, you download image
- **NixOS**: Builds locally on your machine (can also use binary cache)

### 2. State Management
- **BlueBuild**: Image-based, stateless base with `/etc` and `/var` overlays
- **NixOS**: Declarative, but builds unique system profile

### 3. Updates
- **BlueBuild**: Pull new container image
- **NixOS**: Update flake.lock (dependency versions), rebuild

### 4. Customization Model
- **BlueBuild**: Layer on top of base image
- **NixOS**: Declare entire system from scratch (but composable)

### 5. Binary Distribution
- **BlueBuild**: Always distributed as container image
- **NixOS**: Can use binary caches (cache.nixos.org) or build locally

## Advantages of Each

### BlueBuild Advantages
- ✅ Centralized builds (consistent across machines)
- ✅ No local build time
- ✅ Easy to distribute
- ✅ Familiar container workflow

### NixOS Advantages
- ✅ Instant local changes (no CI wait)
- ✅ More granular control
- ✅ Powerful language (can compute configs)
- ✅ Massive package repository (80,000+ packages)
- ✅ Per-user configurations (home-manager)
- ✅ Multiple versions of packages possible

## Common Patterns

### Adding a Custom Package

**BlueBuild:**
```yaml
# Build RPM, add to repo, add repo to recipe
type: rpm-ostree
repos:
  - https://your-repo.com/custom.repo
install:
  - your-custom-package
```

**NixOS:**
```nix
# Create package derivation
packages.your-package = pkgs.stdenv.mkDerivation {
  # ... package definition
};
# Use in system
environment.systemPackages = [ self.packages.your-package ];
```

### Custom Scripts on Boot

**BlueBuild:**
```yaml
type: scripts
scripts:
  - setup.sh  # Runs during image build
```

**NixOS:**
```nix
system.activationScripts.myScript = ''
  echo "Running custom script"
  # ... your commands
'';
```

### Conditionals

**BlueBuild:**
- Limited - mainly via different recipe files or module conditions

**NixOS:**
```nix
# Full programming language!
environment.systemPackages = with pkgs; [
  firefox
] ++ lib.optionals (config.networking.hostName == "vex-htpc") [
  # Only on vex-htpc
  special-package
];
```

## Migration Strategy

If you want to fully switch from BlueBuild to NixOS:

1. ✅ **Set up this flake** with basic config
2. **Install NixOS** on a test machine/VM
3. **Iteratively migrate** each module:
   - Start with system packages
   - Then flatpaks
   - Then GNOME settings
   - Finally custom files/scripts
4. **Test thoroughly** before production
5. **Keep BlueBuild as backup** during transition

You can also **run both**: NixOS on some machines, BlueBuild on others, since both are Git-based and atomic!

## Questions?

- **"Can I build NixOS images?"** - Yes! Look into `nixos-generators` for ISO, VM, cloud images
- **"Can I use containers?"** - Yes! NixOS works great with Docker, Podman, etc.
- **"Do I need to learn Nix language?"** - Basic usage no, advanced yes
- **"Can I copy files like BlueBuild?"** - Yes, but Nix encourages building from source
- **"Is there a GUI?"** - Not really, but NixOS is very well documented

The Nix language is functional and might seem unusual at first, but it's powerful once you get used to it!
