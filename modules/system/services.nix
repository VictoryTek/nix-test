# System Services Configuration
# Networking, sound, and other system services

{ config, pkgs, ... }:

{
  # NETWORKING
  # ----------
  networking.networkmanager.enable = true;
  
  # Firewall - adjust as needed
  networking.firewall = {
    enable = true;
    # allowedTCPPorts = [ ... ];
    # allowedUDPPorts = [ ... ];
  };

  # SOUND / AUDIO
  # -------------
  # Enable PipeWire (modern audio system, what Fedora uses)
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
}
