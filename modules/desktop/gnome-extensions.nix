# GNOME Extensions Configuration
# Similar to BlueBuild's gnome-extensions.yml module
# Matches vex-htpc BlueBuild configuration exactly

{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    # GNOME Extension Manager (GUI app for managing extensions)
    gnome-extension-manager
    
    # Extensions matching your BlueBuild configuration
    gnomeExtensions.dash-to-dock                    # Dash to Dock
    gnomeExtensions.alphabetical-app-grid           # Alphabetical App Grid
    gnomeExtensions.gnome-40-ui-improvements        # Gnome 4x UI Improvements
    # gnomeExtensions.quick-settings-tweaker        # Quick Settings Tweaks (commented in original)
    gnomeExtensions.steal-my-focus                  # Steal my focus window
    # gnomeExtensions.tailscale-qs                  # Tailscale QS (commented in original)
    
    # Additional useful extensions from gschema override enabled-extensions list
    gnomeExtensions.appindicator                    # App indicators support
    gnomeExtensions.caffeine                        # Prevent screen dimming
    gnomeExtensions.blur-my-shell                   # Blur effects
  ];
}

