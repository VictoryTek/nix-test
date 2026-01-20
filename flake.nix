{
  description = "NixOS configuration with modular structure";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, ... }: {
    nixosConfigurations.nix-test = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      
      modules = [
        # Hardware configuration
        ./hardware-configuration.nix
        
        # Main system configuration
        ./configuration.nix
        
        # Modular configurations
        ./modules/system
        ./modules/desktop/gnome.nix
        ./modules/packages/packages.nix
        ./modules/packages/flatpaks.nix
        
        # Home Manager
        home-manager.nixosModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
        }
      ];
    };
  };
}
