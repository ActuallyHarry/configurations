############################################################
# Sentinel Machine
############################################################
{ config, pkgs, ... }:
{
  imports = [
    # Hardware
    ./hardware-configuration.nix
    # Modules
    ../../modules/admin.nix
    ../../modules/keyboard.nix
    ../../modules/localisation.nix
    ../../modules/nix_features.nix
    ../../modules/nix_store.nix
    # Applications
    ../../applications/git.nix
    ../../applications/ssh.nix
    ../../applications/dns.nix
  ];

  boot.loader.grub.enable = true;
  boot.loader.grub.device = "/dev/sda";
  boot.loader.grub.useOSProber = true;

  networking.hostName = "sentinel";
  networking.useDHCP = false;
  networking.interfaces = { 
    ens18 = {
      ipv4.addresses = [ { 
        address = "192.168.1.2";
        prefixLength = 24;
      } ];
    };
  };
  networking.defaultGateway = "192.168.1.1";
  networking.nameservers = [ "192.168.1.2 192.168.1.1"];
  networking.networkmanager.enable = true;


  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.11";

  

}
