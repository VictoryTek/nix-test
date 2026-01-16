# NixOS Flake Architecture Diagram

This document provides visual representations of how everything fits together.

## High-Level Architecture

```
┌─────────────────────────────────────────────────────────────┐
│                         GitHub Repository                    │
│                    (yourusername/vex-htpc-nix)              │
│                                                              │
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐     │
│  │  flake.nix   │  │configuration │  │   home.nix   │     │
│  │   (inputs)   │→ │    .nix      │  │   (user)     │     │
│  │  (outputs)   │  │  (system)    │  │              │     │
│  └──────────────┘  └──────────────┘  └──────────────┘     │
│         ↓                  ↓                  ↓             │
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐     │
│  │ flake.lock   │  │  modules/    │  │   assets/    │     │
│  │  (versions)  │  │   *.nix      │  │ wallpapers   │     │
│  └──────────────┘  └──────────────┘  └──────────────┘     │
└─────────────────────────────────────────────────────────────┘
                            ↓
                    git clone / pull
                            ↓
┌─────────────────────────────────────────────────────────────┐
│                      Your NixOS Machine                      │
│                                                              │
│  ┌──────────────────────────────────────────────────────┐  │
│  │    nixos-rebuild switch --flake .#vex-htpc           │  │
│  └──────────────────────────────────────────────────────┘  │
│                            ↓                                 │
│  ┌──────────────────────────────────────────────────────┐  │
│  │                    Nix Builds:                        │  │
│  │  • Evaluates configuration                            │  │
│  │  • Downloads dependencies (or from cache)             │  │
│  │  • Builds packages if needed                          │  │
│  │  • Creates new system generation                      │  │
│  └──────────────────────────────────────────────────────┘  │
│                            ↓                                 │
│  ┌──────────────────────────────────────────────────────┐  │
│  │                 /nix/store/...                        │  │
│  │  All packages and configurations stored here          │  │
│  └──────────────────────────────────────────────────────┘  │
│                            ↓                                 │
│  ┌──────────────────────────────────────────────────────┐  │
│  │         New Generation Activated                      │  │
│  │  • System packages available                          │  │
│  │  • Services started/configured                        │  │
│  │  • User environment updated                           │  │
│  └──────────────────────────────────────────────────────┘  │
└─────────────────────────────────────────────────────────────┘
```

## Flake Structure

```
┌───────────────────────────────────────────────────────────────┐
│                         flake.nix                             │
├───────────────────────────────────────────────────────────────┤
│                                                               │
│  INPUTS (Dependencies)                                        │
│  ┌─────────────────────────────────────────────────────┐     │
│  │  nixpkgs         → Main package repository          │     │
│  │  home-manager    → User configuration tool           │     │
│  │  nix-flatpak     → Flatpak management                │     │
│  │  (locked in flake.lock)                              │     │
│  └─────────────────────────────────────────────────────┘     │
│                         ↓                                     │
│  OUTPUTS (What you build)                                     │
│  ┌─────────────────────────────────────────────────────┐     │
│  │  nixosConfigurations.vex-htpc                        │     │
│  │    ├─ system = "x86_64-linux"                       │     │
│  │    ├─ modules = [                                    │     │
│  │    │    ./hardware-configuration.nix                │     │
│  │    │    ./configuration.nix                         │     │
│  │    │    home-manager.nixosModules.home-manager      │     │
│  │    │  ]                                              │     │
│  │    └─ home-manager.users.vex = ./home.nix           │     │
│  │                                                      │     │
│  │  packages.x86_64-linux (optional)                   │     │
│  │  devShells.x86_64-linux (optional)                  │     │
│  └─────────────────────────────────────────────────────┘     │
└───────────────────────────────────────────────────────────────┘
```

## Configuration Flow

```
┌──────────────┐
│  flake.nix   │  Entry point
└──────┬───────┘
       │
       ├─────────────────────────┐
       │                         │
       ↓                         ↓
┌──────────────────┐    ┌────────────────────┐
│ configuration.nix│    │     home.nix       │
│  (System Level)  │    │   (User Level)     │
└──────────────────┘    └────────────────────┘
       │                         │
       ├─────────────┬───────────┼──────────┐
       ↓             ↓           ↓          ↓
   ┌────────┐  ┌─────────┐  ┌────────┐  ┌─────────┐
   │Packages│  │Services │  │ dconf  │  │Flatpaks │
   │ (DNF)  │  │(systemd)│  │(GNOME) │  │         │
   └────────┘  └─────────┘  └────────┘  └─────────┘
       │             │           │          │
       └─────────────┴───────────┴──────────┘
                     ↓
              ┌──────────────┐
              │   NixOS      │
              │   System     │
              │ Generation   │
              └──────────────┘
```

## Module System

```
┌────────────────────────────────────────────────────────┐
│                  configuration.nix                     │
│  ┌──────────────────────────────────────────────┐     │
│  │  imports = [                                 │     │
│  │    ./hardware-configuration.nix              │     │
│  │    ./modules/gnome.nix                       │     │
│  │    ./modules/networking.nix                  │     │
│  │  ];                                          │     │
│  └──────────────────────────────────────────────┘     │
│                                                        │
│  All modules get merged together                      │
│                                                        │
│  Each module can:                                      │
│  • Define options                                      │
│  • Set configuration                                   │
│  • Import other modules                                │
└────────────────────────────────────────────────────────┘
```

## Home Manager Integration

```
┌─────────────────────────────────────────────────────────────┐
│                      configuration.nix                      │
│  ┌───────────────────────────────────────────────────────┐ │
│  │  home-manager.nixosModules.home-manager              │ │
│  │    └─ users.vex = import ./home.nix                  │ │
│  └───────────────────────────────────────────────────────┘ │
└─────────────────────────────────────────────────────────────┘
                            ↓
┌─────────────────────────────────────────────────────────────┐
│                        home.nix                             │
│  ┌───────────────────────────────────────────────────────┐ │
│  │  home.packages = [ ... ]           User packages      │ │
│  │  programs.git = { ... }            Program config     │ │
│  │  dconf.settings = { ... }          GNOME settings     │ │
│  │  services.flatpak = { ... }        User services      │ │
│  │  home.file."..." = { ... }         Dotfiles           │ │
│  └───────────────────────────────────────────────────────┘ │
└─────────────────────────────────────────────────────────────┘
                            ↓
              Creates ~/.config, dotfiles, etc.
              in user's home directory
```

## Build Process

```
1. Start
   │
   ↓
┌──────────────────────────────┐
│ nixos-rebuild switch --flake │
│          .#vex-htpc          │
└──────────────────────────────┘
   │
   ↓
2. Read flake.nix
   │
   ↓
3. Check flake.lock (locked versions)
   │
   ├─→ If missing: fetch and lock inputs
   │
   ↓
4. Evaluate configuration
   │
   ├─→ Read configuration.nix
   ├─→ Read home.nix
   ├─→ Merge all modules
   │
   ↓
5. Build derivations
   │
   ├─→ Check binary cache (cache.nixos.org)
   ├─→ Download if available
   ├─→ Build locally if not
   │
   ↓
6. Create new generation
   │
   ├─→ Store in /nix/store
   ├─→ Create symlinks
   ├─→ Update bootloader
   │
   ↓
7. Activate new generation
   │
   ├─→ Start/restart services
   ├─→ Update environment
   ├─→ Apply home-manager changes
   │
   ↓
8. Done! ✓
```

## Generations & Rollback

```
Current System
      ↓
┌─────────────────────────────────────┐
│  /nix/var/nix/profiles/system       │  Current
│         ↓                            │
│  /nix/var/nix/profiles/system-42-link  (Current)
│  /nix/var/nix/profiles/system-41-link  (Previous)
│  /nix/var/nix/profiles/system-40-link
│  /nix/var/nix/profiles/system-39-link
│  ...                                 │
└─────────────────────────────────────┘
      │
      ↓
Each points to /nix/store/...-nixos-system-vex-htpc-24.11/
      │
      ├─→ kernel
      ├─→ init
      ├─→ systemd units
      ├─→ configuration files
      └─→ etc

Rollback = Change symlink to previous generation
```

## Comparison: BlueBuild vs NixOS

```
BlueBuild (Your Current Setup)
─────────────────────────────────────────────
┌──────────┐
│ recipe   │  Defines what to build
│   .yml   │
└────┬─────┘
     │
     ↓
┌──────────┐
│ GitHub   │  Builds container image
│ Actions  │
└────┬─────┘
     │
     ↓
┌──────────┐
│   GHCR   │  Stores image
└────┬─────┘
     │
     ↓
┌──────────┐
│ rpm-     │  Downloads and applies
│ ostree   │
│ rebase   │
└────┬─────┘
     │
     ↓
┌──────────┐
│ System   │  New deployment
└──────────┘


NixOS (New Setup)
─────────────────────────────────────────────
┌──────────┐
│ flake    │  Defines what to build
│   .nix   │
└────┬─────┘
     │
     ↓
┌──────────┐
│  Local   │  Builds locally (or uses cache)
│  Nix     │
│  Build   │
└────┬─────┘
     │
     ↓
┌──────────┐
│ /nix/    │  Stores built packages
│  store   │
└────┬─────┘
     │
     ↓
┌──────────┐
│ nixos-   │  Activates new generation
│ rebuild  │
└────┬─────┘
     │
     ↓
┌──────────┐
│ System   │  New generation
└──────────┘
```

## File Dependencies

```
flake.nix
  ├─ Requires: (none - entry point)
  ├─ Reads: flake.lock (auto-generated)
  └─ Calls: configuration.nix, home.nix

configuration.nix
  ├─ Imported by: flake.nix
  ├─ Imports: hardware-configuration.nix
  │           modules/*.nix (optional)
  └─ Configures: System-wide settings

home.nix
  ├─ Imported by: flake.nix (via home-manager)
  ├─ Imports: home/*/**.nix (optional)
  └─ Configures: User-level settings

hardware-configuration.nix
  ├─ Imported by: configuration.nix
  ├─ Generated by: nixos-generate-config
  └─ Configures: Hardware-specific settings
```

## Update & Deployment Flow

```
Developer Workflow
──────────────────────────────────────────

Edit Files
   ↓
┌────────────┐
│ Edit       │  Modify configuration.nix,
│ Config     │  home.nix, etc.
└─────┬──────┘
      │
      ↓
┌────────────┐
│ Test       │  nixos-rebuild test
│ Locally    │  (no bootloader update)
└─────┬──────┘
      │
      ↓
┌────────────┐
│ Commit     │  git commit
│ to Git     │  git push
└─────┬──────┘
      │
      ↓
┌────────────┐
│ Other      │  git pull
│ Machines   │  nixos-rebuild switch
│ Pull       │
└────────────┘


Updates (Dependencies)
──────────────────────────────────────────

┌────────────┐
│ nix flake  │  Update flake.lock
│ update     │
└─────┬──────┘
      │
      ↓
┌────────────┐
│ nixos-     │  Rebuild with new versions
│ rebuild    │
│ switch     │
└─────┬──────┘
      │
      ↓
┌────────────┐
│ Commit     │  git add flake.lock
│ Lock File  │  git commit -m "Update deps"
└────────────┘
```

## Key Takeaways

1. **flake.nix** = Control center
2. **configuration.nix** = System-wide config
3. **home.nix** = Per-user config
4. **flake.lock** = Ensures reproducibility
5. **Modules** = Composable config pieces
6. **Generations** = Rollback points

Everything is:
- ✅ Declarative (described in files)
- ✅ Reproducible (locked versions)
- ✅ Atomic (all-or-nothing updates)
- ✅ Rollbackable (keep old generations)

Similar to your bootc/ostree setup, but built from config instead of images!
