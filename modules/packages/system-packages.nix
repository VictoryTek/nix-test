# System Packages Configuration
# Similar to BlueBuild's dnf.yml module
# Matches all packages from vex-htpc BlueBuild configuration

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
    
    # System utilities (from dnf.yml)
    wl-clipboard     # Wayland clipboard utilities
    fastfetch        # System information tool (like neofetch)
    inxi             # System information
    blivet          # Partition management (blivet-gui)
    cockpit          # Web-based system management
    pavucontrol      # PulseAudio/PipeWire volume control
    tailscale        # VPN mesh network
    trayscale        # Tailscale GUI for system tray
    tmux             # Terminal multiplexer
    
    # GNOME utilities (already in gnome.nix, but listing here for completeness)
    # gnome.gnome-tweaks  # GNOME customization tool
  ];
}

