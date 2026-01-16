# Vex HTPC - NixOS Edition

A complete NixOS configuration using flakes, recreating the vex-htpc project with declarative, reproducible system management.

## 🎯 What is This?

This project demonstrates how to create a custom NixOS configuration similar to your bootc/ostree setup, but using Nix's declarative approach. Instead of layering changes on a base image, everything is declared in configuration files.

## 📚 Understanding the Structure

### Key Files

```
nix-test/
├── flake.nix              # Entry point - defines inputs and outputs
├── flake.lock             # Lock file (like package-lock.json)
├── configuration.nix      # System-wide configuration
├── home.nix              # User-level configuration (via home-manager)
└── hardware-configuration.nix  # Auto-generated hardware config
```

### What is a Flake?

A **flake** is Nix's modern approach to package and configuration management:

- **Reproducible**: Lock files ensure everyone gets the same versions
- **Composable**: Combine multiple flakes together
- **Self-contained**: All dependencies declared explicitly
- **Multi-output**: Can produce NixOS configs, packages, dev shells, etc.

Think of it like:
- `flake.nix` = package.json + Dockerfile combined
- `flake.lock` = package-lock.json (exact versions)
- Your configs = the application code

## 🚀 How to Use This

### Option 1: Fresh NixOS Install

1. **Install NixOS** with the graphical installer
   - Download from https://nixos.org/download
   - During install, it creates `/etc/nixos/hardware-configuration.nix`

2. **Copy your hardware config**:
   ```bash
   sudo cp /etc/nixos/hardware-configuration.nix ~/nix-test/
   ```

3. **Clone this repo** (or copy your local files):
   ```bash
   git clone https://github.com/yourusername/vex-htpc-nix.git
   cd vex-htpc-nix
   ```

4. **Edit configurations**:
   - Update `configuration.nix`: timezone, hostname, etc.
   - Update `home.nix`: username, git config, etc.

5. **Apply the configuration**:
   ```bash
   sudo nixos-rebuild switch --flake .#vex-htpc
   ```

### Option 2: From GitHub on Existing NixOS

If you already have NixOS installed:

```bash
# Apply directly from GitHub
sudo nixos-rebuild switch --flake github:yourusername/vex-htpc-nix#vex-htpc
```

This is similar to `rpm-ostree rebase` - it pulls your config from GitHub and applies it!

### Option 3: Test Without Installing

Try the configuration in a VM:

```bash
nixos-rebuild build-vm --flake .#vex-htpc
./result/bin/run-vex-htpc-vm
```

## 🔄 Making Changes

Unlike bootc where you layer changes on top, in NixOS you modify the config files:

1. **Edit the config** (e.g., add a package to `configuration.nix`)
2. **Rebuild**: `sudo nixos-rebuild switch --flake .#vex-htpc`
3. **Commit and push** changes to GitHub
4. **Other machines pull** with the same command

### Common Tasks

#### Add a System Package

Edit `configuration.nix`:
```nix
environment.systemPackages = with pkgs; [
  # ... existing packages
  firefox  # Add this
];
```

#### Add a User Package

Edit `home.nix`:
```nix
home.packages = with pkgs; [
  # ... existing packages
  thunderbird  # Add this
];
```

#### Add a Flatpak

Edit `home.nix`:
```nix
services.flatpak.packages = [
  # ... existing flatpaks
  "org.signal.Signal"  # Add this
];
```

#### Change GNOME Settings

Edit `home.nix` dconf settings:
```nix
dconf.settings = {
  "org/gnome/desktop/interface" = {
    color-scheme = "prefer-light";  # Change to light mode
  };
};
```

## 📖 Learning Resources

### Understanding Flakes

1. **Inputs**: External dependencies (like npm dependencies)
   - `nixpkgs`: The main package repository
   - `home-manager`: User config management
   - Lock versions in `flake.lock`

2. **Outputs**: What your flake produces
   - `nixosConfigurations`: System configs
   - `packages`: Custom packages
   - `devShells`: Development environments

3. **Why flakes?**
   - ✅ Reproducible (everyone gets same versions)
   - ✅ Portable (works on any NixOS system)
   - ✅ Composable (combine multiple flakes)
   - ✅ Fast (Nix caches everything)

### Key Concepts

#### Declarative vs Imperative

**Imperative** (traditional Linux):
```bash
sudo dnf install firefox
sudo systemctl enable some-service
# System state is mutable
```

**Declarative** (NixOS):
```nix
environment.systemPackages = [ pkgs.firefox ];
services.some-service.enable = true;
# System state matches config
```

#### Generations

NixOS keeps previous system configurations:
```bash
# List all generations
sudo nix-env --list-generations --profile /nix/var/nix/profiles/system

# Rollback to previous
sudo nixos-rebuild switch --rollback

# Boot into specific generation
# (shows in boot menu)
```

This is similar to ostree's deployment system!

#### Channels vs Flakes

- **Channels** (old way): Like DNF repos, system-wide
- **Flakes** (new way): Per-project, locked versions

You're using flakes (the modern approach).

## 🔧 Customization Guide

### Add Wallpapers

1. Create a `wallpapers/` directory in your flake
2. In `home.nix`:
   ```nix
   home.file.".local/share/backgrounds/vex" = {
     source = ./wallpapers;
     recursive = true;
   };
   ```
3. Set in dconf:
   ```nix
   "org/gnome/desktop/background" = {
     picture-uri = "file://${config.home.homeDirectory}/.local/share/backgrounds/vex/light.jpg";
   };
   ```

### Add GNOME Extensions

1. Search available extensions:
   ```bash
   nix search nixpkgs gnomeExtensions
   ```

2. Add to `configuration.nix`:
   ```nix
   environment.systemPackages = with pkgs; [
     gnomeExtensions.name-here
   ];
   ```

3. Enable in `home.nix`:
   ```nix
   "org/gnome/shell".enabled-extensions = [
     "extension-name@creator"
   ];
   ```

### Create Custom Packages

Create `packages/` directory and add to `flake.nix`:
```nix
outputs = { ... }: {
  packages.x86_64-linux.my-package = pkgs.callPackage ./packages/my-package.nix {};
  # Add to system
  nixosConfigurations.vex-htpc.modules = [
    { environment.systemPackages = [ self.packages.x86_64-linux.my-package ]; }
  ];
};
```

## 🌐 Hosting on GitHub

1. **Create a repo**: `vex-htpc-nix`
2. **Push your flake**:
   ```bash
   git add flake.nix configuration.nix home.nix hardware-configuration.nix
   git commit -m "Initial NixOS configuration"
   git push
   ```

3. **Apply from GitHub** on any NixOS machine:
   ```bash
   sudo nixos-rebuild switch --flake github:yourusername/vex-htpc-nix#vex-htpc
   ```

4. **Updates**: Push changes to GitHub, then pull:
   ```bash
   # Update flake.lock with latest versions
   nix flake update
   
   # Rebuild with updates
   sudo nixos-rebuild switch --flake github:yourusername/vex-htpc-nix#vex-htpc
   ```

## 🆚 NixOS vs bootc/ostree

| Aspect | bootc/ostree | NixOS |
|--------|-------------|-------|
| Base | Container image | Configuration files |
| Updates | Rebase to new image | Rebuild from config |
| Customization | Layer packages | Edit config |
| Rollback | Previous deployment | Previous generation |
| Reproducibility | Image-based | Declarative |
| Speed | Download image | Build/cache locally |

Both are **atomic** and **reproducible**, just different approaches!

## 🐛 Troubleshooting

### "Error: experimental features"
Enable flakes:
```bash
mkdir -p ~/.config/nix
echo "experimental-features = nix-command flakes" >> ~/.config/nix/nix.conf
```

### Syntax Errors in Nix Files
```bash
# Check syntax
nix flake check
```

### Build Fails
```bash
# Show verbose output
sudo nixos-rebuild switch --flake .#vex-htpc --show-trace
```

### See What Changed
```bash
# Compare generations
nix store diff-closures /nix/var/nix/profiles/system-{OLD,NEW}-link
```

## 📚 More Learning

- **Official Docs**: https://nixos.org/manual/nixos/stable/
- **Nix Pills**: https://nixos.org/guides/nix-pills/ (deep dive tutorial)
- **Home Manager**: https://nix-community.github.io/home-manager/
- **Wiki**: https://nixos.wiki/
- **Search Packages**: https://search.nixos.org/

## 🎓 Next Steps

1. ✅ Set up this basic configuration
2. 📝 Customize packages and settings
3. 🎨 Add your wallpapers and themes
4. 🔌 Configure your hardware specifics
5. 🚀 Push to GitHub and use across machines
6. 🧪 Experiment with modules and overlays
7. 📦 Package custom software

Welcome to declarative system management! 🎉
