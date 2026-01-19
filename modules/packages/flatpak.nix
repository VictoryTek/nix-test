# Flatpak Configuration
# Similar to BlueBuild's default-flatpaks.yml module
# Complete list matching vex-htpc BlueBuild configuration

{ config, pkgs, ... }:

{
  # Enable Flatpak support
  services.flatpak.enable = true;

  # Note: To declaratively manage flatpaks in NixOS, you'll need to install them manually
  # or use a tool like nix-flatpak in home-manager
  
  # First, add Flathub repository:
  # flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
  
  # INSTALL - System-wide flatpaks matching your default-flatpaks.yml:
  # flatpak install -y flathub io.github.kolunmi.Bazaar              # Bazaar Software Center
  # flatpak install -y flathub com.bitwarden.desktop                 # Bitwarden
  # flatpak install -y flathub com.brave.Browser                     # Brave Browser
  # flatpak install -y flathub com.mattjakeman.ExtensionManager      # Extension Manager
  # flatpak install -y flathub com.github.tchx84.Flatseal            # FlatSeal
  # flatpak install -y flathub io.freetubeapp.FreeTube               # FreeTube
  # flatpak install -y flathub it.mijorus.gearlever                  # Gearlever
  # flatpak install -y flathub org.gnome.TextEditor                  # Gnome Text Editor
  # flatpak install -y flathub org.gnome.Loupe                       # Image Viewer
  # flatpak install -y flathub io.gitlab.librewolf-community         # LibreWolf Browser
  # flatpak install -y flathub io.missioncenter.MissionCenter        # Mission Center
  # flatpak install -y flathub tv.plex.PlexDesktop                   # Plex
  # flatpak install -y flathub com.rustdesk.RustDesk                 # Rustdesk
  # flatpak install -y flathub org.gnome.seahorse.Application        # Seahorse
  # flatpak install -y flathub dev.deedles.Trayscale                 # Tray Scale
  # flatpak install -y flathub com.github.unrud.VideoDownloader      # Video Downloader
  # flatpak install -y flathub io.github.flattool.Warehouse          # Warehouse

  # REMOVE - Flatpaks to remove (if they exist):
  # flatpak uninstall -y org.gnome.eog                               # Eye of GNOME
  # flatpak uninstall -y io.github.nokse22.Exhibit
  # flatpak uninstall -y org.gnome.Weather
  # flatpak uninstall -y org.gnome.clocks
  # flatpak uninstall -y org.gnome.Characters

  # TODO: Consider adding declarative-flatpak or nix-flatpak for automated management
  # This would allow you to manage flatpaks just like nix packages in home.nix
}

