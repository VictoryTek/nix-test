# Learning Path: Understanding Nix & Flakes

A structured guide to help you learn Nix and flakes progressively.

## Phase 1: Understanding the Basics (Week 1)

### Day 1-2: Nix Language Fundamentals

**What to learn:**
- Nix is a functional, lazy programming language
- Everything is an expression that returns a value
- No statements, no side effects (mostly)

**Basic Syntax:**
```nix
# This is a comment

# Simple values
42                    # integer
"hello"              # string
true                 # boolean
[ 1 2 3 ]           # list
{ key = "value"; }   # attribute set (like JSON object)

# Variables (immutable)
let
  name = "World";
  greeting = "Hello, ${name}!";
in
  greeting            # Returns: "Hello, World!"

# Functions
let
  double = x: x * 2;
  add = x: y: x + y;  # Curried function
in
  double 5            # Returns: 10
  add 3 4             # Returns: 7

# With keyword (brings attributes into scope)
let
  config = { name = "vex"; version = "1.0"; };
in
  with config; "Name: ${name}, Version: ${version}"
```

**Try it yourself:**
```bash
# Open Nix REPL
nix repl

# Try expressions
nix-repl> 1 + 1
nix-repl> builtins.toString 42
nix-repl> builtins.length [ 1 2 3 ]
```

**Resources:**
- [Nix Language Basics](https://nixos.org/manual/nix/stable/language/)
- Practice with `nix repl`

### Day 3-4: Understanding Derivations

**What to learn:**
- A derivation is a build recipe
- `pkgs.stdenv.mkDerivation` is the basic builder
- Everything in `/nix/store` is built from derivations

**Example:**
```nix
pkgs.stdenv.mkDerivation {
  pname = "hello";
  version = "1.0";
  
  src = fetchurl {
    url = "https://example.com/hello.tar.gz";
    sha256 = "...";
  };
  
  buildPhase = ''
    gcc hello.c -o hello
  '';
  
  installPhase = ''
    mkdir -p $out/bin
    cp hello $out/bin/
  '';
}
```

**Key concepts:**
- `$out` - output directory in Nix store
- Build happens in isolation
- All dependencies must be declared

**Try it yourself:**
```bash
# See what a package looks like
nix edit nixpkgs#hello

# Build a package
nix build nixpkgs#hello

# See where it was built
ls -l result
```

### Day 5-7: Configuration Basics

**What to learn:**
- NixOS modules system
- How `configuration.nix` works
- The `options` and `config` pattern

**Read through your generated configs:**
1. Open `configuration.nix` and read the comments
2. Look up options: https://search.nixos.org/options
3. Try changing small things:
   ```nix
   # Add a package
   environment.systemPackages = [ pkgs.hello ];
   
   # Enable a service
   services.openssh.enable = true;
   ```

4. Rebuild and see the changes:
   ```bash
   sudo nixos-rebuild test --flake .#vex-htpc
   ```

## Phase 2: Mastering Flakes (Week 2)

### Understanding flake.nix Structure

```nix
{
  description = "...";
  
  # INPUTS: What you depend on
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    # More inputs...
  };
  
  # OUTPUTS: What you produce
  outputs = { self, nixpkgs, ... }: {
    # Multiple outputs possible:
    nixosConfigurations.hostname = { ... };
    packages.x86_64-linux.myapp = { ... };
    devShells.x86_64-linux.default = { ... };
  };
}
```

**Key concepts:**
- **Inputs are locked** in `flake.lock` (reproducibility!)
- **Outputs are functions** that take inputs and return things
- **Flakes are pure** (mostly) - no network access during eval

### Flake Commands

```bash
# Show flake structure
nix flake show

# Update all inputs
nix flake update

# Update specific input
nix flake lock --update-input nixpkgs

# Check flake (validate)
nix flake check

# Get metadata
nix flake metadata
```

### Exercise: Create a Dev Shell

Add to your `flake.nix`:
```nix
outputs = { self, nixpkgs, ... }: {
  # ... existing outputs
  
  devShells.x86_64-linux.default = 
    let pkgs = nixpkgs.legacyPackages.x86_64-linux;
    in pkgs.mkShell {
      packages = with pkgs; [
        python3
        nodejs
        git
      ];
      
      shellHook = ''
        echo "Development environment loaded!"
      '';
    };
};
```

Then:
```bash
nix develop
# Now you're in a shell with python3, nodejs, git!
```

## Phase 3: Home Manager Deep Dive (Week 3)

### Understanding Home Manager

Home Manager lets you declaratively manage:
- Dotfiles
- User packages
- Application configs
- User services

**Module system:**
```nix
{ config, pkgs, ... }:
{
  # Options you enable/configure
  programs.git = {
    enable = true;
    userName = "Your Name";
    userEmail = "email@example.com";
    extraConfig = {
      init.defaultBranch = "main";
    };
  };
  
  # Files you create
  home.file.".config/custom/config.toml".text = ''
    key = "value"
  '';
  
  # Packages for this user
  home.packages = [ pkgs.htop ];
}
```

### Exercise: Customize Your Shell

In `home.nix`:
```nix
programs.bash = {
  enable = true;
  shellAliases = {
    ll = "ls -la";
    gs = "git status";
    rebuild = "sudo nixos-rebuild switch --flake .#vex-htpc";
  };
  initExtra = ''
    # Custom bash config
    export EDITOR=vim
  '';
};

programs.starship = {
  enable = true;
  settings = {
    add_newline = false;
    character = {
      success_symbol = "[➜](bold green)";
      error_symbol = "[➜](bold red)";
    };
  };
};
```

## Phase 4: Advanced Topics (Week 4+)

### Overlays

Modify or add packages:
```nix
nixpkgs.overlays = [
  (final: prev: {
    # Modify existing package
    cowsay = prev.cowsay.overrideAttrs (old: {
      # modifications
    });
    
    # Add new package
    my-script = prev.writeScriptBin "my-script" ''
      #!/bin/sh
      echo "Hello!"
    '';
  })
];
```

### Custom Modules

Create `modules/my-module.nix`:
```nix
{ config, lib, pkgs, ... }:

with lib;

{
  options.myModule = {
    enable = mkEnableOption "My custom module";
    setting = mkOption {
      type = types.str;
      default = "default";
      description = "A custom setting";
    };
  };
  
  config = mkIf config.myModule.enable {
    environment.systemPackages = [ pkgs.hello ];
    # More config based on options
  };
}
```

Import in `configuration.nix`:
```nix
imports = [ ./modules/my-module.nix ];
myModule.enable = true;
```

### Secrets Management

Consider using:
- `sops-nix` - encrypted secrets in Git
- `agenix` - age-encrypted secrets
- `pass` - password store

Example with sops-nix:
```nix
inputs.sops-nix.url = "github:Mic92/sops-nix";

# In configuration:
sops.secrets.password = {
  sopsFile = ./secrets.yaml;
  owner = "user";
};
```

### Multiple Machines

One flake, multiple configs:
```nix
outputs = { self, nixpkgs, ... }: {
  nixosConfigurations = {
    desktop = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [ ./machines/desktop/configuration.nix ];
    };
    
    laptop = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [ ./machines/laptop/configuration.nix ];
    };
    
    server = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [ ./machines/server/configuration.nix ];
    };
  };
};
```

Share common config:
```nix
# common.nix
{ ... }: {
  environment.systemPackages = [ /* shared packages */ ];
  # shared settings
}

# desktop/configuration.nix
{ ... }: {
  imports = [ ../common.nix ];
  # desktop-specific config
}
```

## Learning Resources by Topic

### Official Documentation
- **Nix Manual**: https://nixos.org/manual/nix/stable/
- **NixOS Manual**: https://nixos.org/manual/nixos/stable/
- **Nixpkgs Manual**: https://nixos.org/manual/nixpkgs/stable/

### Tutorials
- **Nix Pills**: https://nixos.org/guides/nix-pills/ (comprehensive)
- **Zero to Nix**: https://zero-to-nix.com/ (beginner-friendly)
- **Nix.dev**: https://nix.dev/ (guides and tutorials)

### Community
- **NixOS Discourse**: https://discourse.nixos.org/
- **NixOS Wiki**: https://nixos.wiki/
- **Reddit**: r/NixOS
- **Matrix/IRC**: #nixos on Matrix

### Video Resources
- **Nix Hour**: https://www.youtube.com/@vimjoyer
- **Burke Libbey**: https://www.youtube.com/@burkelibbey

### Search & Browse
- **Package Search**: https://search.nixos.org/packages
- **Options Search**: https://search.nixos.org/options
- **Home Manager Options**: https://nix-community.github.io/home-manager/options.xhtml

## Practice Projects

1. **Week 1**: Get basic system running with GNOME
2. **Week 2**: Add all your flatpaks and extensions
3. **Week 3**: Customize GNOME settings via dconf
4. **Week 4**: Add custom scripts/packages
5. **Week 5**: Create a development environment
6. **Week 6**: Set up multi-machine configuration
7. **Week 7**: Build a custom package
8. **Week 8**: Share configuration publicly

## Common Pitfalls

1. **Forgetting semicolons** in attribute sets
2. **Mutation**: Nix values are immutable
3. **Paths**: `./.` copies to Nix store, `"./."` is just a string
4. **Infinite recursion**: Be careful with `rec { }` and `let ... in`
5. **Mixing old & new**: Use flakes consistently
6. **Hardware differences**: Don't share `hardware-configuration.nix`

## Success Indicators

You'll know you're getting it when:
- ✅ You can read & understand most .nix files
- ✅ You know where to search for options/packages
- ✅ You can add packages without looking it up
- ✅ You understand what `nixos-rebuild` does
- ✅ You're comfortable with rollbacks
- ✅ You can explain inputs vs outputs
- ✅ You know when to use system vs home packages

## Next Level Goals

After mastering the basics:
- Build your own Nix packages
- Contribute to nixpkgs
- Create custom NixOS modules
- Set up automated deployments
- Build infrastructure with NixOps/Colmena
- Create custom ISO images
- Package your own software

Remember: **Nix has a learning curve, but it's worth it!** The reproducibility and declarative nature will change how you think about system configuration.

Take it slow, experiment in VMs, and don't be afraid to break things - you can always rollback! 🚀
