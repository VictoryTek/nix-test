# GNOME dconf Settings Configuration
# Replicates vex-htpc gschema-overrides (zz1-vex.gschema.override)
# These settings should be configured in home.nix using dconf

{ config, pkgs, ... }:

{
  # Note: These settings are typically set per-user in home.nix using dconf.settings
  # This file documents the system-level implications

  # The actual dconf settings should be added to home.nix like this:
  #
  # dconf.settings = {
  #   "org/gnome/desktop/interface" = {
  #     color-scheme = "prefer-dark";
  #     accent-color = "teal";
  #     icon-theme = "kora";
  #     cursor-theme = "Bibata-Modern-Classic";
  #     cursor-size = 24;
  #   };
  #
  #   "org/gnome/settings-daemon/plugins/power" = {
  #     sleep-inactive-ac-type = "nothing";
  #     sleep-inactive-battery-type = "nothing";
  #   };
  #
  #   "org/gnome/desktop/screensaver" = {
  #     lock-enabled = false;
  #   };
  #
  #   "org/gnome/shell" = {
  #     disable-user-extensions = false;
  #     enabled-extensions = [
  #       "AlphabeticalAppGrid@stuarthayhurst"
  #       "appindicatorsupport@rgcjonas.gmail.com"
  #       "blur-my-shell@aunetx"
  #       "caffeine@patapon.info"
  #       "dash-to-dock@micxgx.gmail.com"
  #       "gnome-ui-tune@itstime.tech"
  #       "steal-my-focus-window@steal-my-focus-window"
  #     ];
  #     favorite-apps = [
  #       "com.brave.Browser.desktop"
  #       "io.gitlab.librewolf-community.desktop"
  #       "tv.plex.PlexDesktop.desktop"
  #       "io.freetubeapp.FreeTube.desktop"
  #       "org.gnome.Nautilus.desktop"
  #       "com.mitchellh.ghostty.desktop"
  #     ];
  #   };
  #
  #   "org/gnome/shell/extensions/dash-to-dock" = {
  #     dock-position = "LEFT";
  #   };
  # };

  # System-level GNOME configuration
  # GDM logo can be set here (requires custom configuration)
  # services.xserver.displayManager.gdm.logo = "${custom-logo-path}/vex.png";
}
