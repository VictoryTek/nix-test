# GNOME Desktop Environment Configuration
# Similar to BlueBuild's module-recipes approach for modularity

{ config, pkgs, ... }:

{
  # Enable the X11 windowing system
  services.xserver.enable = true;
  services.xserver.xkb.layout = "us";
  
  # GNOME Desktop Manager
  services.displayManager.gdm.enable = true;
  services.desktopManager.gnome.enable = true;
  
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
    gnome-tweaks
    dconf-editor
    nautilus
    sushi  # File previewer for Nautilus
  ];

  # Power Management
  # Prevent automatic suspension
  services.logind.settings = {
    Login = {
      HandleLidSwitch = "ignore";
      HandleLidSwitchDocked = "ignore";
      HandleLidSwitchExternalPower = "ignore";
    };
  };
}
