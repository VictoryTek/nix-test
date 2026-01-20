{ config, pkgs, ... }:

{
  # Desktop environment configuration
  
  # Enable the X11 windowing system (required even for Wayland sessions)
  services.xserver.enable = true;

  # Enable the GNOME Desktop Environment with Wayland
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.displayManager.gdm.wayland = true;
  services.xserver.desktopManager.gnome.enable = true;

  # Prefer Wayland over X11
  environment.sessionVariables = {
    NIXOS_OZONE_WL = "1"; # Hint Electron apps to use Wayland
    MOZ_ENABLE_WAYLAND = "1"; # Enable Wayland for Firefox
  };

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  # Enable touchpad support (for laptops)
  # services.xserver.libinput.enable = true;

  # Exclude some default GNOME applications (optional)
  environment.gnome.excludePackages = with pkgs; [
    gnome-tour
    epiphany # web browser
    geary # email reader
  ];
}
