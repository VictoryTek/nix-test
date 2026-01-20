# Fonts Configuration
# System-wide font packages

{ config, pkgs, ... }:

{
  fonts.packages = with pkgs; [
    noto-fonts
    noto-fonts-cjk-sans
    noto-fonts-color-emoji
    liberation_ttf
    fira-code
    fira-code-symbols
    nerd-fonts.fira-code  # For terminal icons with starship
    
    # Add more fonts as needed
    # font-awesome
    # dejavu_fonts
  ];
}
