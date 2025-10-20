############################################################
# {Hostname} Machine
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
    ../../modules/sops.nix
    ../../modules/ssl_wildcard.nix
    # Applications
    ../../applications/git.nix
    ../../applications/ssh.nix
    ../../applications/incus.nix
  ];

  #Incus Settings
  homeIncus = {
     hostname = "centurion";
     ipv4 = "192.168.90.253";
     machineId = "c466cbf8";
  };


  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "centurion";
  networking.useDHCP = false;
  networking.interfaces = {
    enp0s31f6 = {
       useDHCP = false;
    };
    br0 = {
      ipv4.addresses = [ {
        address = "192.168.90.253";
        prefixLength = 16;
      } ];
    };
  };

  networking.bridges.br0.interfaces = ["enp0s31f6"];
 
  networking.defaultGateway = {
    address= "192.168.0.1";
    interface= "br0";
  };
  networking.nameservers = [ "192.168.10.2 192.168.0.1"];
  networking.networkmanager.enable = true;


  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "25.05";

  

}
