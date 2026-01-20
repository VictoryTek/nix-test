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
        ./modules/desktop
        ./modules/packages
        
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
        
        # Include home-manager as a NixOS module
        # This lets you manage system AND user configs in one place
        home-manager.nixosModules.home-manager
        {
          # Configure home-manager
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          # Point to your user configuration
          home-manager.users.nimda = import ./home.nix;
          
          # Optionally pass through inputs to home.nix
          home-manager.extraSpecialArgs = { inherit nix-flatpak; };
        }
      ];
    };
  };
}
