# GNOME Desktop Environment Configuration
# Similar to BlueBuild's module-recipes approach for modularity

{ config, pkgs, ... }:

{
  # Enable the X11 windowing system and GNOME
  services.xserver = {
    enable = true;
    
    # GNOME Desktop Manager
    displayManager.gdm.enable = true;
    desktopManager.gnome.enable = true;
    
    # Keyboard layout
    xkb.layout = "us";
  };
  
  # Exclude some default GNOME apps (similar to your remove list)
  environment.gnome.excludePackages = with pkgs; [
    gnome-photos
    gnome-tour
    gnome-characters
    gnome-clocks
    epiphany  # GNOME Web browser
    geary     # Email client
    totem     # Video player
  ];

  # GNOME-specific utilities
  environment.systemPackages = with pkgs; [
    gnome.gnome-tweaks
    dconf-editor
    gnome.nautilus
    gnome.sushi  # File previewer for Nautilus
  ];

  # Power Management
  # Prevent automatic suspension
  services.logind = {
    lidSwitch = "ignore";
    lidSwitchDocked = "ignore";
    lidSwitchExternalPower = "ignore";
  };
}
