{ config, pkgs, ... }:

{
  # System-wide packages
  
  environment.systemPackages = with pkgs; [
    # Essential utilities
    vim
    wget
    curl
    git
    htop
    tree
    
    # File management
    unzip
    zip
    
    # Network tools
    networkmanagerapplet
    
    # Development tools
    # vscode
    # gcc
    
    # GNOME utilities
    gnome.gnome-tweaks
    gnomeExtensions.appindicator
  ];

  # Enable Flatpak (optional)
  services.flatpak.enable = true;

  # Fonts
  fonts.packages = with pkgs; [
    noto-fonts
    noto-fonts-cjk
    noto-fonts-emoji
    liberation_ttf
    fira-code
    fira-code-symbols
  ];
}
