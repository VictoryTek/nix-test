# Flatpak Configuration
# Similar to BlueBuild's default-flatpaks.yml module
# Lists all flatpaks from your BlueBuild configuration

{ config, pkgs, ... }:

{
  # Enable Flatpak support
  services.flatpak.enable = true;

  # Note: To declaratively manage flatpaks in NixOS, you can:
  # 1. Use the nix-flatpak Home Manager module (recommended)
  # 2. Manually install them after system setup
  # 3. Use systemd services to auto-install them on boot
  
  # For now, this enables flatpak. You can install your apps with:
  # flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
  
  # Then install your apps from your BlueBuild list:
  # System-wide flatpaks matching your default-flatpaks.yml:
  #   flatpak install -y flathub io.github.kolunmi.Bazaar
  #   flatpak install -y flathub com.bitwarden.desktop
  #   flatpak install -y flathub com.brave.Browser
  #   flatpak install -y flathub com.mattjakeman.ExtensionManager
  #   flatpak install -y flathub com.github.tchx84.Flatseal
  #   flatpak install -y flathub io.freetubeapp.FreeTube
  #   flatpak install -y flathub it.mijorus.gearlever
  #   flatpak install -y flathub org.gnome.TextEditor
  #   flatpak install -y flathub org.gnome.Loupe
  #   flatpak install -y flathub io.gitlab.librewolf-community
  #   flatpak install -y flathub io.missioncenter.MissionCenter
  #   flatpak install -y flathub tv.plex.PlexDesktop
  #   flatpak install -y flathub com.rustdesk.RustDesk
  #   flatpak install -y flathub org.gnome.seahorse.Application
  #   flatpak install -y flathub dev.deedles.Trayscale
  #   flatpak install -y flathub com.github.unrud.VideoDownloader
  #   flatpak install -y flathub io.github.flattool.Warehouse

  # TODO: Consider adding nix-flatpak for declarative flatpak management
  # This would allow you to manage flatpaks just like nix packages
}
