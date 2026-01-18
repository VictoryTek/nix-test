# System Packages Configuration
# Similar to BlueBuild's dnf.yml module

{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    # Essential tools
    nano
    wget
    curl
    git
    
    # Terminal emulator - Ghostty
    ghostty  
    
    # Shell enhancement
    starship  # Your prompt customization
    
    # Icon theme - Kora
    kora-icon-theme
    
    # Cursor theme
    bibata-cursors
    
    # System utilities
    wl-clipboard  # Wayland clipboard utilities
    fastfetch     # System information tool (like neofetch)
    inxi          # System information
    
    # Add more packages from your DNF list as needed
    # You can search for packages at https://search.nixos.org/packages
  ];
}
