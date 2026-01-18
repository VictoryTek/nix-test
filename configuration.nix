# NixOS System Configuration
# This file defines system-wide settings (like packages, services, users)
# Similar to how BlueBuild recipes define system-level modifications
#
# MODULAR STRUCTURE:
# This configuration now follows a modular approach similar to BlueBuild's
# module-recipes. Each concern is separated into its own module file.

{ config, pkgs, ... }:

{
  # IMPORTS
  # -------
  # Import hardware configuration and all modular components
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

  # BASIC SYSTEM INFO
  # -----------------
  
  # Hostname - this identifies your machine on the network
  networking.hostName = "nimda-htpc";
  
  # Timezone
  time.timeZone = "America/Chicago"; # Change to your timezone
  
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

  # USERS
  # -----
  # Define your user account
  
  users.users.nimda = {
    isNormalUser = true;
    description = "Nimda User";
    extraGroups = [ 
      "networkmanager" 
      "wheel"  # Allows sudo
      "video"
      "audio"
    ];
    # You can set an initial password or use password-less login
    # initialPassword = "changeme";
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
