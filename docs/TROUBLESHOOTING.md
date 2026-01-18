# Troubleshooting Guide

Common issues you might encounter while learning NixOS and how to solve them.

## Build Errors

### Error: "experimental features not enabled"

```
error: experimental Nix feature 'flakes' is disabled
```

**Solution:**
```bash
mkdir -p ~/.config/nix
echo "experimental-features = nix-command flakes" >> ~/.config/nix/nix.conf
```

Or system-wide in `configuration.nix`:
```nix
nix.settings.experimental-features = [ "nix-command" "flakes" ];
```

---

### Error: "file not found in flake"

```
error: getting status of '/nix/store/.../hardware-configuration.nix': No such file or directory
```

**Cause**: File exists locally but not in Git  
**Solution**: 
```bash
git add hardware-configuration.nix
# Flakes only see Git-tracked files!
```

**Or** if testing locally:
```bash
# Add untracked files temporarily
git add --intent-to-add .
```

---

### Error: "infinite recursion encountered"

```
error: infinite recursion encountered
```

**Cause**: Circular reference in your config  
**Common culprits**:
- Using `rec { }` incorrectly
- Referencing config value that references itself

**Solution**: Use `let ... in` instead of `rec`:
```nix
# Bad:
rec {
  a = b;
  b = a;  # Infinite loop!
}

# Good:
let
  a = "value";
  b = a;
in { inherit a b; }
```

---

### Error: "attribute missing"

```
error: attribute 'somePackage' missing
```

**Cause**: Package doesn't exist or typo  
**Solution**:
```bash
# Search for the package
nix search nixpkgs somePackage

# Check if it exists
nix eval nixpkgs#somePackage.meta.available
```

---

### Error: "hash mismatch"

```
error: hash mismatch in fixed-output derivation
```

**Cause**: Downloaded file hash doesn't match expected  
**Solution**:
```bash
# For flake inputs:
nix flake lock --update-input problematic-input

# For fetchurl in packages:
# Update the hash in the derivation
```

## Syntax Errors

### Missing Semicolons

```nix
# Wrong:
{
  option1 = value1
  option2 = value2  # Missing semicolon!
}

# Correct:
{
  option1 = value1;
  option2 = value2;
}
```

### Missing `in` keyword

```nix
# Wrong:
let
  x = 5;
x + 10  # Missing 'in'!

# Correct:
let
  x = 5;
in
  x + 10
```

### String Interpolation

```nix
# Wrong:
"Hello ${name}"  # If name isn't a string

# Correct:
"Hello ${toString name}"
# or
"Hello ${builtins.toString name}"
```

## System Issues

### Can't Boot After Update

**Solution 1**: Boot into previous generation
1. Restart computer
2. At GRUB/systemd-boot menu, select previous generation
3. Once booted, investigate:
   ```bash
   sudo nixos-rebuild switch --rollback
   ```

**Solution 2**: From live USB
```bash
# Mount your system
sudo mount /dev/sdXY /mnt
sudo mount /dev/sdXZ /mnt/boot  # EFI partition

# Chroot in
sudo nixos-enter --root /mnt

# Rollback
nixos-rebuild switch --rollback
```

---

### Out of Disk Space

**Cause**: `/nix/store` grows over time  
**Solution**:
```bash
# Remove old generations
sudo nix-collect-garbage --delete-older-than 7d

# Remove all old generations (keeps only current)
sudo nix-collect-garbage -d

# Optimize store (deduplication)
nix-store --optimise
```

**Prevention** in `configuration.nix`:
```nix
nix.gc = {
  automatic = true;
  dates = "weekly";
  options = "--delete-older-than 30d";
};
nix.settings.auto-optimise-store = true;
```

---

### Service Won't Start

```bash
# Check service status
systemctl status service-name.service

# View logs
journalctl -u service-name.service -f

# Check if enabled
systemctl list-unit-files | grep service-name
```

**Common cause**: Missing required options  
**Solution**: Check NixOS options:
```bash
# Search for service options
man configuration.nix | grep -A20 "services.service-name"
```

---

### X11/Wayland Issues

**Symptoms**: Black screen, can't login, graphics glitches

**Debug**:
```bash
# Check display manager logs
journalctl -u display-manager.service

# Check X server logs
cat /var/log/X.0.log

# Try different session
# At login screen, select different desktop environment
```

**Common fixes**:
```nix
# Ensure proper video drivers
hardware.opengl.enable = true;
hardware.opengl.driSupport = true;

# For NVIDIA:
services.xserver.videoDrivers = [ "nvidia" ];
```

## Flake Issues

### Can't Update Flake

```
error: cannot fetch input 'nixpkgs'
```

**Cause**: Network issue or invalid URL  
**Solution**:
```bash
# Check network
ping github.com

# Try specific input
nix flake lock --update-input nixpkgs

# Check flake.nix for typos in URLs
```

---

### Flake Evaluation is Slow

**Cause**: Large `nixpkgs` evaluation, many imports  
**Solutions**:

1. **Use binary cache**:
   ```nix
   nix.settings = {
     substituters = [ "https://cache.nixos.org" ];
     trusted-public-keys = [ ... ];
   };
   ```

2. **Limit evaluations**:
   ```bash
   # Use --no-update-lock-file when not updating
   nixos-rebuild switch --flake .#vex-htpc --no-update-lock-file
   ```

3. **Profile evaluation**:
   ```bash
   nix eval --profile .#nixosConfigurations.vex-htpc.config.system.build.toplevel
   ```

---

### Flake Lock Conflicts

**Symptoms**: Different machines have different versions  
**Solution**:
```bash
# On machine with desired versions:
git add flake.lock
git commit -m "Lock dependencies"
git push

# On other machines:
git pull
sudo nixos-rebuild switch --flake .#vex-htpc
```

## Home Manager Issues

### Home Manager Config Not Applied

**Symptoms**: Changes in `home.nix` don't take effect  
**Checks**:

1. **Using NixOS module?** Rebuild system:
   ```bash
   sudo nixos-rebuild switch --flake .#vex-htpc
   ```

2. **Standalone?** Rebuild home:
   ```bash
   home-manager switch --flake .#vex
   ```

3. **Check for errors**:
   ```bash
   home-manager switch --show-trace
   ```

---

### Conflicting Packages

```
error: collision between packages foo and bar
```

**Cause**: Same file in multiple packages  
**Solution**: Use package priorities or wrap:
```nix
home.packages = [
  (pkgs.lowPrio pkgs.foo)  # Lower priority
  pkgs.bar
];
```

---

### dconf Settings Not Applied

**Symptoms**: GNOME settings revert

**Causes**:
1. GNOME overriding settings
2. Syntax errors
3. Wrong schema path

**Solutions**:
```bash
# Check dconf path
gsettings list-schemas | grep gnome

# Manually test setting
dconf write /org/gnome/desktop/interface/color-scheme "'prefer-dark'"

# Check for errors
journalctl --user -xe
```

**In home.nix**, ensure quotes are correct:
```nix
dconf.settings = {
  "org/gnome/desktop/interface" = {
    color-scheme = "prefer-dark";  # String, not 'prefer-dark'
  };
};
```

## Package Issues

### Package Build Fails

```
error: builder for '/nix/store/...-package.drv' failed
```

**Debug**:
```bash
# Build with verbose output
nix build nixpkgs#package --print-build-logs

# Try older version
nix build nixpkgs/nixos-23.11#package
```

**Report upstream**:
- Check nixpkgs issues: https://github.com/NixOS/nixpkgs/issues
- Test with `nixos-unstable`

---

### Package Not Found

```
error: attribute 'packageName' missing
```

**Solutions**:
```bash
# Search correct name
nix search nixpkgs packagename

# Check if removed
# Visit: https://search.nixos.org/packages

# Try alternative spelling
nix search nixpkgs package-name
```

---

### Flatpak Issues

**Can't install flatpaks**:
```bash
# Ensure flatpak enabled
services.flatpak.enable = true;

# Add flathub manually if needed
flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo

# Check remotes
flatpak remotes
```

**Flatpak apps won't start**:
```bash
# Check permissions
flatpak info --show-permissions app.id

# Use Flatseal to adjust
flatpak run com.github.tchx84.Flatseal
```

## Network Issues

### DNS Not Working

**Symptom**: Can't resolve hostnames

**Solution**:
```nix
networking.nameservers = [ "8.8.8.8" "1.1.1.1" ];
# Or use systemd-resolved:
services.resolved.enable = true;
```

---

### WiFi Not Working

**Check**:
```bash
# List interfaces
ip link

# NetworkManager status
nmcli device status

# Enable if needed:
systemctl enable NetworkManager
systemctl start NetworkManager
```

**In configuration.nix**:
```nix
networking.networkmanager.enable = true;
# Add user to group:
users.users.username.extraGroups = [ "networkmanager" ];
```

## Performance Issues

### Slow Rebuilds

**Optimizations**:

1. **Use binary cache**:
   ```nix
   nix.settings.substituters = [
     "https://cache.nixos.org"
     "https://nix-community.cachix.org"
   ];
   ```

2. **Parallel builds**:
   ```nix
   nix.settings.max-jobs = 4;
   nix.settings.cores = 4;
   ```

3. **Don't rebuild unnecessarily**:
   ```bash
   # Use --no-update-lock-file when not updating
   nixos-rebuild switch --flake .#vex-htpc --no-update-lock-file
   ```

---

### High Memory Usage

**Nix evaluation** can use significant RAM

**Solutions**:
- Close other applications during rebuild
- Add swap space
- Limit parallel builds:
  ```nix
  nix.settings.max-jobs = 2;
  ```

## Getting Help

### Gather Information

Before asking for help, gather:

```bash
# NixOS version
nixos-version

# Hardware info
nixos-generate-config --show-hardware-config

# Flake info
nix flake metadata

# Error logs
nixos-rebuild switch --show-trace 2>&1 | tee error.log
```

### Where to Ask

1. **NixOS Discourse**: https://discourse.nixos.org/
   - Best for: General questions, config help
   
2. **GitHub Issues**: https://github.com/NixOS/nixpkgs/issues
   - Best for: Package bugs, feature requests
   
3. **Matrix Chat**: #nixos:matrix.org
   - Best for: Quick questions, real-time help
   
4. **Reddit**: r/NixOS
   - Best for: Discussions, showcasing configs

### Provide Context

When asking for help:
- ✅ NixOS version
- ✅ Relevant config snippets
- ✅ Full error messages
- ✅ What you've tried
- ✅ Minimal reproducible example

## Emergency Recovery

### System Unbootable

1. **Boot from NixOS ISO**
2. **Mount system**:
   ```bash
   sudo mount /dev/sdXY /mnt
   sudo mount /dev/sdXZ /mnt/boot
   ```
3. **Enter system**:
   ```bash
   sudo nixos-enter --root /mnt
   ```
4. **Rollback or fix**:
   ```bash
   nixos-rebuild switch --rollback
   # Or edit configs and rebuild
   ```

### Forgot Password

```bash
# From ISO, after mounting and entering:
passwd username
```

### Broken Config

If your config is broken and you can't rebuild:

```bash
# Edit the config
vim /etc/nixos/configuration.nix

# Or revert from Git
cd /path/to/flake
git revert HEAD
nixos-rebuild switch --flake .#vex-htpc
```

## Prevention Tips

1. **Always test first**:
   ```bash
   nixos-rebuild test --flake .#vex-htpc
   # If good, then:
   nixos-rebuild switch --flake .#vex-htpc
   ```

2. **Commit working configs**:
   ```bash
   git add .
   git commit -m "Working config with X feature"
   ```

3. **Use VMs for experiments**:
   ```bash
   nixos-rebuild build-vm --flake .#vex-htpc
   ./result/bin/run-*-vm
   ```

4. **Keep generations**:
   ```nix
   # Don't be too aggressive with garbage collection
   nix.gc.options = "--delete-older-than 30d";  # Not 7d
   ```

5. **Read before applying**:
   ```bash
   # Check what will change
   nixos-rebuild dry-build --flake .#vex-htpc
   ```

Remember: NixOS is designed for recovery. You can always rollback! 🔄
