{ config, pkgs, ... }:

{
  # Flatpak configuration
  
  # Enable Flatpak
  services.flatpak.enable = true;

  # Add Flathub repository
  systemd.services.flatpak-repo = {
    wantedBy = [ "multi-user.target" ];
    path = [ pkgs.flatpak ];
    script = ''
      flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
    '';
  };

  # Optional: Install specific Flatpak applications
  # Uncomment and add applications you want to install:
  # systemd.services.flatpak-install = {
  #   wantedBy = [ "multi-user.target" ];
  #   path = [ pkgs.flatpak ];
  #   script = ''
  #     flatpak install -y flathub org.mozilla.firefox
  #     flatpak install -y flathub com.spotify.Client
  #   '';
  # };
}
