# 🎯 Vex HTPC - NixOS Flake Project

Welcome to your NixOS learning journey! This project recreates your vex-htpc configuration using Nix flakes.

## 📁 Project Files

### Core Configuration Files
- **[flake.nix](flake.nix)** - Entry point with inputs & outputs (heavily commented)
- **[configuration.nix](configuration.nix)** - System-wide settings (packages, services, GNOME)
- **[home.nix](home.nix)** - User-level configuration (dconf, flatpaks, dotfiles)
- **[hardware-configuration.nix](hardware-configuration.nix)** - Hardware-specific settings (template)

### Documentation
- **[README.md](README.md)** - Main guide: what this is, how to use it, and next steps
- **[COMMANDS.md](COMMANDS.md)** - Quick reference for common NixOS commands
- **[LEARNING_PATH.md](LEARNING_PATH.md)** - 4-week structured learning curriculum
- **[MIGRATION_GUIDE.md](MIGRATION_GUIDE.md)** - BlueBuild/bootc → NixOS translation
- **[PROJECT_STRUCTURE.md](PROJECT_STRUCTURE.md)** - File organization patterns
- **[TROUBLESHOOTING.md](TROUBLESHOOTING.md)** - Common issues and solutions

### Other Files
- **[.gitignore](.gitignore)** - Git ignore patterns for Nix projects
- **flake.lock** - Dependency lock file (auto-generated after first build)

## 🚀 Quick Start

1. **Read First**: [README.md](README.md) - Understand what flakes are
2. **Reference**: [COMMANDS.md](COMMANDS.md) - Keep this handy while working
3. **Learn**: [LEARNING_PATH.md](LEARNING_PATH.md) - Follow the week-by-week guide
4. **Compare**: [MIGRATION_GUIDE.md](MIGRATION_GUIDE.md) - See how concepts map from BlueBuild

## 🎓 Learning Approach

### For Complete Beginners
1. Read [README.md](README.md) first
2. Try the example in a VM
3. Follow [LEARNING_PATH.md](LEARNING_PATH.md) week 1
4. Experiment with small changes
5. Use [TROUBLESHOOTING.md](TROUBLESHOOTING.md) when stuck

### For Those Familiar with Linux
1. Skim [README.md](README.md) for concepts
2. Check [MIGRATION_GUIDE.md](MIGRATION_GUIDE.md) for translations
3. Use [COMMANDS.md](COMMANDS.md) as reference
4. Start customizing the configs

### Understanding the Flow

```
YOU ─→ Edit *.nix files
  ↓
flake.nix coordinates everything
  ↓
configuration.nix ─→ System changes (requires sudo)
  ↓
home.nix ─→ User changes
  ↓
Run: nixos-rebuild switch --flake .#vex-htpc
  ↓
Changes applied! (rollback anytime)
```

## 🔄 NixOS vs Your Current Setup

| Your vex-htpc | This NixOS Project |
|---------------|-------------------|
| BlueBuild recipes | Nix configuration files |
| GitHub Actions builds image | You build locally (or use cache) |
| `rpm-ostree rebase` | `nixos-rebuild switch` |
| Container image on GHCR | Flake on GitHub |
| Reboot to apply | Most changes instant |

**Same concept**: Declarative, reproducible, Git-based, atomic updates!

## 📦 What's Configured

This flake includes:
- ✅ GNOME desktop environment
- ✅ Dash to Dock + extensions
- ✅ Starship prompt
- ✅ Flatpak support with your apps
- ✅ Power management settings
- ✅ Icon themes (Kora, Bibata cursors)
- ✅ All your favorite apps
- ✅ Dark theme preference

## 🎯 Next Steps

1. **Install NixOS** (or use a VM to test)
2. **Copy your hardware config**:
   ```bash
   sudo nixos-generate-config --show-hardware-config > hardware-configuration.nix
   ```
3. **Customize the configs** (timezone, username, packages)
4. **Apply the configuration**:
   ```bash
   sudo nixos-rebuild switch --flake .#vex-htpc
   ```
5. **Commit and push** to GitHub
6. **Pull on other machines** and rebuild!

## 🆘 Need Help?

- **Stuck?** → [TROUBLESHOOTING.md](TROUBLESHOOTING.md)
- **Don't understand something?** → [LEARNING_PATH.md](LEARNING_PATH.md)
- **How do I...?** → [COMMANDS.md](COMMANDS.md)
- **What's different from BlueBuild?** → [MIGRATION_GUIDE.md](MIGRATION_GUIDE.md)

## 💡 Key Concepts to Understand

### Flakes
- Modern Nix system for dependencies
- Lock file ensures reproducibility
- Can output multiple things (configs, packages, shells)

### Declarative Configuration
- Everything in config files
- No manual package installs
- System state matches config

### Generations
- Every rebuild creates a new generation
- Boot menu shows all generations
- Rollback anytime without data loss

### Home Manager
- Manages user-level configurations
- Like dotfiles, but declarative
- Part of your system config

## 🌟 Why NixOS?

Compared to your bootc/ostree setup:
- ✅ **Faster iteration** (no CI wait, build locally)
- ✅ **More granular** (control everything)
- ✅ **Huge package repo** (80k+ packages)
- ✅ **Dev environments** (per-project shells)
- ✅ **Rollback anytime** (like ostree)
- ✅ **Same Git workflow** (push/pull configs)

## 📚 Resources

### Official
- [NixOS Manual](https://nixos.org/manual/nixos/stable/)
- [Package Search](https://search.nixos.org/packages)
- [Options Search](https://search.nixos.org/options)

### Community
- [NixOS Discourse](https://discourse.nixos.org/)
- [NixOS Wiki](https://nixos.wiki/)
- [r/NixOS](https://reddit.com/r/NixOS)

### Learning
- [Zero to Nix](https://zero-to-nix.com/)
- [Nix Pills](https://nixos.org/guides/nix-pills/)
- [nix.dev](https://nix.dev/)

## 🎉 Welcome to NixOS!

You're embarking on a learning journey that will change how you think about system configuration. Take it slow, experiment in VMs, and don't be afraid to break things - you can always rollback!

The Nix community is friendly and helpful. When you get stuck, reach out on Discourse or Matrix.

**Happy hacking!** 🚀

---

*Generated for learning Nix and flakes • Based on vex-htpc BlueBuild project*
