# Hardware Configuration Template
# This is a placeholder that allows the flake to evaluate
# When you install NixOS, generate your real hardware config:
#   sudo nixos-generate-config --show-hardware-config > hardware-configuration.nix

{ config, lib, pkgs, modulesPath, ... }:

{
  imports = [ ];

  # Placeholder - will be replaced with actual hardware detection
  boot.loader.systemd-boot.enable = lib.mkDefault true;
  boot.loader.efi.canTouchEfiVariables = lib.mkDefault true;

  fileSystems."/" = lib.mkDefault {
    device = "/dev/disk/by-label/nixos";
    fsType = "ext4";
  };

  networking.useDHCP = lib.mkDefault true;
  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
}
