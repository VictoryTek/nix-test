# Quick Reference - Common Commands

## Building & Switching

```bash
# Apply configuration (most common command)
sudo nixos-rebuild switch --flake .#vex-htpc

# Test configuration without switching boot default
sudo nixos-rebuild test --flake .#vex-htpc

# Build but don't activate
sudo nixos-rebuild build --flake .#vex-htpc

# Update flake.lock (get newest versions)
nix flake update

# Update specific input
nix flake lock --update-input nixpkgs
```

## From GitHub

```bash
# Apply config directly from GitHub
sudo nixos-rebuild switch --flake github:yourusername/vex-htpc-nix#vex-htpc

# Update and apply
nix flake update github:yourusername/vex-htpc-nix
sudo nixos-rebuild switch --flake github:yourusername/vex-htpc-nix#vex-htpc
```

## Managing Generations

```bash
# List all generations
sudo nix-env --list-generations --profile /nix/var/nix/profiles/system

# Rollback to previous generation
sudo nixos-rebuild switch --rollback

# Delete old generations (free space)
sudo nix-collect-garbage --delete-older-than 30d

# Delete all old generations
sudo nix-collect-garbage -d
```

## Package Management

```bash
# Search for packages
nix search nixpkgs firefox

# Search for GNOME extensions
nix search nixpkgs gnomeExtensions

# Get package info
nix eval nixpkgs#firefox.meta.description

# Try a package without installing
nix run nixpkgs#firefox
```

## Debugging

```bash
# Check flake syntax
nix flake check

# Show verbose build output
sudo nixos-rebuild switch --flake .#vex-htpc --show-trace

# See what's in your current system
nix-store -q --references /run/current-system

# Compare two generations
nix store diff-closures /nix/var/nix/profiles/system-{52,53}-link
```

## Home Manager (User Config)

```bash
# Switch home-manager config separately (if not using NixOS module)
home-manager switch --flake .#vex

# List home-manager generations
home-manager generations
```

## Flake Operations

```bash
# Show flake metadata
nix flake metadata

# Show flake outputs
nix flake show

# Lock specific versions
nix flake lock

# Add a new input
# Edit flake.nix, then:
nix flake lock
```

## Git Workflow

```bash
# Initialize repo
git init
git add .
git commit -m "Initial NixOS configuration"

# Push to GitHub
git remote add origin https://github.com/yourusername/vex-htpc-nix.git
git push -u origin main

# After making changes
git add configuration.nix home.nix
git commit -m "Update GNOME settings"
git push

# Test before pushing
sudo nixos-rebuild test --flake .#vex-htpc
```

## Useful Queries

```bash
# What packages are installed?
nix-env -qa

# What's using disk space?
nix path-info -rsSh /run/current-system | sort -k2 -h

# Which package provides a file?
nix-locate bin/firefox

# Show package dependencies
nix-store -q --tree /run/current-system
```
