# Fonts Configuration
# System-wide font packages

{ config, pkgs, ... }:

{
  fonts.packages = with pkgs; [
    noto-fonts
    noto-fonts-cjk
    noto-fonts-emoji
    liberation_ttf
    fira-code
    fira-code-symbols
    nerdfonts  # For terminal icons with starship
    
    # Add more fonts as needed
    # font-awesome
    # dejavu_fonts
  ];
}
