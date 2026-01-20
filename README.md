# NixOS Modular Configuration

Modular NixOS configuration organized by category.

## Fresh Install Setup

On a fresh NixOS installation:

```bash
cd /etc/nixos
sudo git clone https://github.com/VictoryTek/nix-test
sudo cp -r nix-test/* .
sudo rm -rf nix-test

# 5. Build and switch to the flake configuration
sudo nixos-rebuild switch --flake .#nix-test


# 3. Remove old files and generate fresh hardware configuration
sudo rm -rf /etc/nixos/*
sudo nixos-generate-config --show-hardware-config > /etc/nixos/hardware-configuration.nix

# 4. Clone the repository again
cd /etc/nixos
sudo git clone https://github.com/VictoryTek/nix-test
sudo cp -r nix-test/* .
sudo rm -rf nix-test

# 5. Build and switch to the flake configuration
```

## Structure

- **desktop/** - Desktop environment (GNOME, Wayland)
- **packages/** - System packages and Flatpaks
- **system/** - System services and configuration
