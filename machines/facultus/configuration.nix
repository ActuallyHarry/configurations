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
     hostname = "facultus";
     ipv4 = "192.168.90.251";
  };


  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "facultus";
  networking.useDHCP = false;
  networking.interfaces = {
    enp6s0 = {
      ipv4.addresses = [ {
        address = "192.168.90.251";
        prefixLength = 16;
      } ];
    };
  };
  networking.defaultGateway = "192.168.0.1";
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
