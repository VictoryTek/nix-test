# System Services Configuration
# Networking, sound, and other system services
# Matches vex-htpc BlueBuild configuration

{ config, pkgs, ... }:

{
  # NETWORKING
  # ----------
  networking.networkmanager.enable = true;
  
  # Firewall - adjust as needed
  networking.firewall = {
    enable = true;
    # Allow Cockpit web interface
    allowedTCPPorts = [ 9090 ];
    # allowedUDPPorts = [ ... ];
    # Allow Tailscale
    checkReversePath = "loose";
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

  # TAILSCALE
  # ---------
  # VPN mesh network (from vex-htpc dnf.yml)
  services.tailscale = {
    enable = true;
    # Optional: Use MagicDNS
    useRoutingFeatures = "client";
  };

  # COCKPIT
  # -------
  # Web-based system management interface
  # Access at https://localhost:9090
  services.cockpit = {
    enable = true;
    port = 9090;
  };
}

