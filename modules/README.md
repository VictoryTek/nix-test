# NixOS Modules - Modular Configuration System

This directory contains modular NixOS configuration files, inspired by the BlueBuild project's module-recipes approach. Each module handles a specific aspect of the system configuration, making it easy to enable, disable, or customize individual components.

## Structure

```
modules/
├── desktop/           # Desktop environment configurations
│   ├── gnome.nix                # GNOME desktop setup
│   └── gnome-extensions.nix     # GNOME extensions
├── packages/          # Package management
│   ├── system-packages.nix      # System-wide packages
│   └── flatpak.nix              # Flatpak support and apps
└── system/            # System-level configurations
    ├── fonts.nix                # Font packages
    └── services.nix             # System services (audio, networking, etc.)
```

## How It Works

The main `configuration.nix` file imports these modules:

```nix
imports = [
  ./hardware-configuration.nix
  
  # Desktop modules
  ./modules/desktop/gnome.nix
  ./modules/desktop/gnome-extensions.nix
  
  # Package modules
  ./modules/packages/system-packages.nix
  ./modules/packages/flatpak.nix
  
  # System modules
  ./modules/system/fonts.nix
  ./modules/system/services.nix
];
```

## Enabling/Disabling Modules

To disable a module, simply comment it out or remove it from the imports list in `configuration.nix`:

```nix
imports = [
  ./hardware-configuration.nix
  ./modules/desktop/gnome.nix
  # ./modules/desktop/gnome-extensions.nix  # Disabled
  ./modules/packages/system-packages.nix
  # ... etc
];
```

Then rebuild your system:
```bash
sudo nixos-rebuild switch --flake .#nimda-htpc
```

## Module Descriptions

### Desktop Modules

#### `gnome.nix`
- Enables GNOME desktop environment
- Configures GDM display manager
- Excludes unwanted default GNOME apps
- Includes GNOME utilities (Tweaks, dconf-editor)
- Configures power management settings

#### `gnome-extensions.nix`
- Installs GNOME extensions system-wide
- Includes: Dash to Dock, Alphabetical App Grid, Caffeine, etc.
- Extensions are activated/configured in `home.nix`

### Package Modules

#### `system-packages.nix`
- Essential CLI tools (git, wget, curl)
- Terminal emulator (Ghostty)
- Shell enhancements (Starship)
- Icon and cursor themes
- System utilities

#### `flatpak.nix`
- Enables Flatpak support
- Documents the flatpaks from your BlueBuild configuration
- Note: Flatpaks must be installed manually or via Home Manager

### System Modules

#### `fonts.nix`
- System-wide font packages
- Noto fonts, Fira Code, Nerd Fonts
- Emoji and CJK support

#### `services.nix`
- Networking (NetworkManager, firewall)
- Audio (PipeWire with ALSA, PulseAudio, and JACK support)
- Other system services

## Adding New Modules

1. Create a new `.nix` file in the appropriate subdirectory
2. Structure it like the existing modules:
   ```nix
   { config, pkgs, ... }:
   {
     # Your configuration here
   }
   ```
3. Add the module to the imports list in `configuration.nix`
4. Rebuild: `sudo nixos-rebuild switch --flake .#nimda-htpc`

## Example: Creating a Custom Module

```nix
# modules/system/custom-service.nix
{ config, pkgs, ... }:
{
  services.myservice = {
    enable = true;
    # ... other options
  };
}
```

Then add to `configuration.nix`:
```nix
imports = [
  # ... existing imports
  ./modules/system/custom-service.nix
];
```

## Comparison to BlueBuild

| BlueBuild | NixOS Modules |
|-----------|---------------|
| `recipes/vex-htpc.yml` | `configuration.nix` (main entry point) |
| `module-recipes/dnf.yml` | `modules/packages/system-packages.nix` |
| `module-recipes/default-flatpaks.yml` | `modules/packages/flatpak.nix` |
| `module-recipes/gnome-extensions.yml` | `modules/desktop/gnome-extensions.nix` |
| `module-recipes/files.yml` | `home.nix` (for user files) |

## Benefits of This Approach

1. **Modularity**: Easy to enable/disable features
2. **Maintainability**: Each concern is isolated
3. **Reusability**: Modules can be shared across configurations
4. **Clarity**: Clear separation of responsibilities
5. **Similar to BlueBuild**: Familiar structure for those coming from BlueBuild

## Further Customization

- Edit individual module files to add/remove packages or change settings
- Create new modules for specific use cases (gaming, development, etc.)
- Use NixOS options to make modules configurable with parameters
- Consider creating a separate repository for reusable modules

## Resources

- [NixOS Manual - Modules](https://nixos.org/manual/nixos/stable/#sec-writing-modules)
- [Nix Pills](https://nixos.org/guides/nix-pills/)
- [BlueBuild Documentation](https://blue-build.org)
