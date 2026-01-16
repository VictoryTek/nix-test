# NixOS System Configuration
# This file defines system-wide settings (like packages, services, users)
# Similar to how BlueBuild recipes define system-level modifications

{ config, pkgs, ... }:

{
  # BASIC SYSTEM INFO
  # -----------------
  
  # Hostname - this identifies your machine on the network
  networking.hostName = "vex-htpc";
  
  # Timezone
  time.timeZone = "America/New_York"; # Change to your timezone
  
  # Internationalization
  i18n.defaultLocale = "en_US.UTF-8";


  # BOOT AND KERNEL
  # ---------------
  
  # Use the latest Linux kernel (similar to Fedora's approach)
  boot.kernelPackages = pkgs.linuxPackages_latest;
  
  # Bootloader configuration
  boot.loader = {
    systemd-boot.enable = true;
    efi.canTouchEfiVariables = true;
  };


  # DESKTOP ENVIRONMENT - GNOME
  # ----------------------------
  
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
    totem     # Video player (you'll use different apps)
  ];


  # SYSTEM PACKAGES
  # ---------------
  # These are installed system-wide (available to all users)
  
  environment.systemPackages = with pkgs; [
    # Essential tools
    vim
    wget
    curl
    git
    
    # Terminal emulator - Ghostty (if available, otherwise kitty)
    # Note: Ghostty might need to be built separately or use kitty as alternative
    kitty  # Alternative terminal until ghostty is in nixpkgs
    
    # Shell enhancement
    starship  # Your prompt customization
    
    # GNOME Extensions Manager
    gnomeExtensions.extension-manager
    
    # Icon theme - Kora
    kora-icon-theme
    
    # Cursor theme
    bibata-cursors
    
    # System utilities similar to your needs
    gnome.gnome-tweaks
    dconf-editor
    
    # File manager enhancements
    gnome.nautilus
    gnome.sushi  # File previewer for Nautilus
    
    # Other tools from your config
    wl-clipboard  # Wayland clipboard utilities
  ];


  # GNOME EXTENSIONS
  # ----------------
  # Install extensions system-wide
  # In home.nix we'll configure them
  
  environment.systemPackages = with pkgs; [
    gnomeExtensions.dash-to-dock
    gnomeExtensions.alphabetical-app-grid
    gnomeExtensions.caffeine
    gnomeExtensions.blur-my-shell
    gnomeExtensions.appindicator
    # Add more extensions as needed from pkgs.gnomeExtensions.*
  ];


  # FONTS
  # -----
  
  fonts.packages = with pkgs; [
    noto-fonts
    noto-fonts-cjk
    noto-fonts-emoji
    liberation_ttf
    fira-code
    fira-code-symbols
    nerdfonts  # For terminal icons with starship
  ];


  # FLATPAK SUPPORT
  # ---------------
  # Enable Flatpak (your config uses many flatpaks)
  
  services.flatpak.enable = true;
  
  # Automatically add Flathub repository
  # In NixOS you can also declaratively manage flatpaks using nix-flatpak


  # NETWORKING
  # ----------
  
  networking.networkmanager.enable = true;
  
  # Firewall - adjust as needed
  networking.firewall = {
    enable = true;
    # allowedTCPPorts = [ ... ];
    # allowedUDPPorts = [ ... ];
  };


  # SOUND
  # -----
  
  # Enable PipeWire (modern audio system, what Fedora 43 uses)
  sound.enable = true;
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
  };


  # USERS
  # -----
  # Define your user account
  
  users.users.vex = {
    isNormalUser = true;
    description = "Vex User";
    extraGroups = [ 
      "networkmanager" 
      "wheel"  # Allows sudo
      "video"
      "audio"
    ];
    # You can set an initial password or use password-less login
    # initialPassword = "changeme";
  };


  # POWER MANAGEMENT
  # ----------------
  # Similar to your gschema override for power settings
  
  # Prevent automatic suspension
  services.logind = {
    lidSwitch = "ignore";
    lidSwitchDocked = "ignore";
    lidSwitchExternalPower = "ignore";
  };


  # SYSTEM STATE VERSION
  # --------------------
  # This defines the NixOS release version you're using
  # Don't change this unless you know what you're doing
  # It's for maintaining compatibility across updates
  
  system.stateVersion = "24.11"; # Change to current NixOS version


  # NIX SETTINGS
  # ------------
  # Enable flakes and the new nix command
  
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  
  # Automatic garbage collection (cleanup old generations)
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 30d";
  };
  
  # Optimize store (deduplication)
  nix.settings.auto-optimise-store = true;
}
