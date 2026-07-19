{ modulesPath, config, pkgs, lib, ... }:
{
  imports = [
    # Include the default incus configuration.
    "${modulesPath}/virtualisation/lxc-container.nix"
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
    ../../modules/split_dns.nix
    # Applications
    ../../applications/git.nix
    ../../applications/ssh.nix
    ../../applications/servarr.nix
    ../../applications/torrent.nix

  ];

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";

  networking.hostName = "noxium";
  networking.useDHCP = false;
  networking.interfaces = {
    eth0 = {
      ipv4.addresses = [ {
        address = "192.168.40.99";
        prefixLength = 16;
      } ];
    };
  };
  networking.defaultGateway = "192.168.40.254";
  networking.nameservers = ["127.0.0.53"];


  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "25.05";



}
