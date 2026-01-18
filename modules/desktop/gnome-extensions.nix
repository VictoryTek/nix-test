# GNOME Extensions Configuration
# Similar to BlueBuild's gnome-extensions.yml module

{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    # GNOME Extension Manager (similar to ExtensionManager flatpak)
    gnomeExtensions.extension-manager
    
    # Extensions matching your BlueBuild configuration
    gnomeExtensions.dash-to-dock
    gnomeExtensions.alphabetical-app-grid
    
    # Additional useful extensions
    gnomeExtensions.caffeine
    gnomeExtensions.blur-my-shell
    gnomeExtensions.appindicator
    
    # You can add more from https://search.nixos.org/packages?channel=unstable&query=gnomeExtensions
    # Examples:
    # gnomeExtensions.quick-settings-tweaker
    # gnomeExtensions.tailscale-qs
  ];
}
