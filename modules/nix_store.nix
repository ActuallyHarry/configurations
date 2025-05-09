##########################################################################
# Settings for Garbage Collection and Optimisation of the Nix Store
##########################################################################
{config, pkgs, ... }:
{
  # Garbage Collection
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 7d";
    
  };

  # limit number of configurations allows settings to be garbage collected
  boot.loader.grub.configurationLimit = 5;
  boot.loader.systemd-boot.configurationLimit = 5;
  boot.loader.generic-extlinux-compatible.configurationLimit =5;

  # Optimisation
  nix.optimise = {
    automatic = true;
  };

}
