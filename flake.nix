{
  # WHAT IS A FLAKE?
  # A flake is Nix's modern way of managing dependencies and configurations.
  # Think of it like a package.json or requirements.txt, but more powerful.
  # It locks dependencies, provides reproducible builds, and can output
  # multiple things (NixOS configs, packages, dev shells, etc.)
  
  description = "Nimda HTPC - A custom NixOS configuration with GNOME";

  # INPUTS: External dependencies for your flake
  # These are like the "dependencies" in package.json
  # Each input is fetched and locked in flake.lock (like package-lock.json)
  inputs = {
    # nixpkgs: The main repository of Nix packages
    # Think of this as the Fedora repositories, but for Nix
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    
    # home-manager: Manages user-level configurations (dotfiles, etc.)
    # Similar to how you'd configure things in ~/.config
    # But declarative and reproducible
    home-manager = {
      url = "github:nix-community/home-manager";
      # This means home-manager will use the same nixpkgs as above
      # Prevents version conflicts
      inputs.nixpkgs.follows = "nixpkgs";
    };
    
    # Optional: For better GNOME extension support
    # This provides many GNOME extensions packaged for Nix
    nix-flatpak.url = "github:gmodena/nix-flatpak";
  };

  # OUTPUTS: What your flake produces
  # This is where you define what gets built
  # The '@' syntax destructures the inputs
  outputs = { self, nixpkgs, home-manager, nix-flatpak, ... }: {
    
    # nixosConfigurations: Defines NixOS system configurations
    # The name "nix-test" becomes your hostname
    # You can have multiple configs in one flake (e.g., desktop, laptop, server)
    nixosConfigurations.nix-test = nixpkgs.lib.nixosSystem {
      # System architecture - change to "aarch64-linux" for ARM
      system = "x86_64-linux";
      
      # modules: A list of configuration files and modules to include
      # Think of these as building blocks that get merged together
      modules = [        
        # Your main system configuration (what we'll create next)
        ./configuration.nix
        
        # Include home-manager as a NixOS module
        # This lets you manage system AND user configs in one place
        home-manager.nixosModules.home-manager
        {
          # Configure home-manager
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          # Point to your user configuration
          home-manager.users.vex = import ./home.nix;
          
          # Optionally pass through inputs to home.nix
          home-manager.extraSpecialArgs = { inherit nix-flatpak; };
        }
      ];
    };
  };
}
