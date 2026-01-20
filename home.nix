# Home Manager Configuration
# This manages USER-level configurations (dotfiles, GNOME settings, etc.)
# Think of this as your personal customizations, separate from system config

{ config, pkgs, nix-flatpak, ... }:

{
  # This value determines the Home Manager release that your
  # configuration is compatible with.
  home.stateVersion = "24.11";
  
  # Username and home directory
  home.username = "nimda";
  home.homeDirectory = "/home/nimda";


  # USER PACKAGES
  # -------------
  # These are installed for this user only
  
  home.packages = with pkgs; [
    # Text editor
    gnome-text-editor
    
    # Image viewer
    loupe
    
    # System monitor alternative
    mission-center
    
    # Additional utilities
    seahorse  # Password manager GUI
    
    # You can add more here
  ];


  # DECLARATIVE FLATPAK MANAGEMENT
  # ------------------------------
  # This uses nix-flatpak to declaratively manage flatpaks
  # Much cleaner than manually running flatpak install commands
  
  imports = [ nix-flatpak.homeManagerModules.nix-flatpak ];
  
  services.flatpak = {
    enable = true;
    
    # Define flatpaks to install
    packages = [
      "io.github.kolunmi.Bazaar"
      "com.bitwarden.desktop"
      "com.brave.Browser"
      "com.mattjakeman.ExtensionManager"
      "com.github.tchx84.Flatseal"
      "io.freetubeapp.FreeTube"
      "it.mijorus.gearlever"
      "io.gitlab.librewolf-community"
      "io.missioncenter.MissionCenter"
      "tv.plex.PlexDesktop"
      "com.rustdesk.RustDesk"
      "dev.deedles.Trayscale"
      "com.github.unrud.VideoDownloader"
      "io.github.flattool.Warehouse"
    ];
    
    # Automatically update flatpaks
    update.auto = {
      enable = true;
      onCalendar = "weekly";
    };
  };


  # DCONF SETTINGS
  # --------------
  # This is how you configure GNOME settings declaratively
  # Similar to your gschema overrides
  
  dconf.settings = {
    # Desktop Interface Settings
    "org/gnome/desktop/interface" = {
      color-scheme = "prefer-dark";
      # Accent color (teal)
      accent-color = "teal";
      icon-theme = "kora";
      cursor-theme = "Bibata-Modern-Classic";
      cursor-size = 24;
    };
    
    # Power Management
    "org/gnome/settings-daemon/plugins/power" = {
      sleep-inactive-ac-type = "nothing";
      sleep-inactive-battery-type = "nothing";
    };
    
    # Screensaver
    "org/gnome/desktop/screensaver" = {
      lock-enabled = false;
    };
    
    # Shell Settings
    "org/gnome/shell" = {
      disable-user-extensions = false;
      
      # Enabled extensions
      enabled-extensions = [
        "AlphabeticalAppGrid@stuarthayhurst"
        "appindicatorsupport@rgcjonas.gmail.com"
        "blur-my-shell@aunetx"
        "caffeine@patapon.info"
        "dash-to-dock@micxgx.gmail.com"
      ];
      
      # Favorite apps (shown in dock)
      favorite-apps = [
        "com.brave.Browser.desktop"
        "io.gitlab.librewolf-community.desktop"
        "tv.plex.PlexDesktop.desktop"
        "io.freetubeapp.FreeTube.desktop"
        "org.gnome.Nautilus.desktop"
        "kitty.desktop"  # or ghostty when available
      ];
    };
    
    # Dash to Dock Settings
    "org/gnome/shell/extensions/dash-to-dock" = {
      dock-position = "LEFT";
    };
    
    # Background Settings
    "org/gnome/desktop/background" = {
      # Wallpapers from vex-htpc (light theme)
      picture-uri = "file://${config.home.homeDirectory}/.local/share/wallpapers/vex-bb-light.jxl";
      picture-uri-dark = "file://${config.home.homeDirectory}/.local/share/wallpapers/vex-bb-dark.jxl";
    };
  };


  # STARSHIP PROMPT
  # ---------------
  # Your shell prompt configuration (from vex-htpc)
  
  programs.starship = {
    enable = true;
    # Use custom starship config from vex-htpc
    # The config file will be linked to ~/.config/starship.toml
  };
  
  # Enable starship for bash
  programs.bash = {
    enable = true;
    initExtra = ''
      eval "$(starship init bash)"
    '';
  };


  # GIT CONFIGURATION
  # -----------------
  # Configure git (if you use it)
  
  programs.git = {
    enable = true;
    settings = {
      user = {
        name = "Your Name";
        email = "your.email@example.com";
      };
    };
  };


  # FILE MANAGEMENT
  # ---------------
  # Create directories and files in your home directory
  
  home.file = {
    # Starship config file from vex-htpc
    ".config/starship.toml".source = ./starship.toml;
    
    # Wallpapers from vex-htpc
    ".local/share/wallpapers/vex-bb-light.jxl".source = ./wallpapers/vex-bb-light.jxl;
    ".local/share/wallpapers/vex-bb-dark.jxl".source = ./wallpapers/vex-bb-dark.jxl;
  };


  # SESSION VARIABLES
  # -----------------
  
  home.sessionVariables = {
    EDITOR = "vim";
  };


  # Let Home Manager install and manage itself
  programs.home-manager.enable = true;
}
