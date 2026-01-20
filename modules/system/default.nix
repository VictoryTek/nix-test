{ config, pkgs, ... }:

{
  # System-level configurations
  
  # Enable sound
  sound.enable = true;
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  # Enable CUPS for printing
  services.printing.enable = true;

  # Enable OpenSSH daemon
  services.openssh.enable = true;

  # Firewall configuration
  networking.firewall.enable = true;
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];

  # Enable automatic garbage collection
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 30d";
  };

  # Auto-upgrade system
  system.autoUpgrade = {
    enable = false; # Set to true to enable automatic updates
    allowReboot = false;
  };
}
