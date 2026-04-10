############################################################
# Nomadica  Machine
############################################################
{
  config,
  pkgs,
  ...
}: {
  imports = [
    # Hardware
    ./hardware-configuration.nix
    # Modules
    ../../modules/keyboard.nix
    ../../modules/localisation.nix
    ../../modules/nix_features.nix
    ../../modules/nix_store.nix
    ../../modules/audio.nix
    ../../modules/bluetooth.nix
    ../../modules/fonts.nix
    ../../modules/desktop.nix
    ../../modules/zsh.nix
    # Applications
    ../../applications/git.nix
    ../../applications/core.nix
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "nomadica";
  networking.networkmanager.enable = true;

  users.users.harry = {
    isNormalUser = true;
    description = "harry";
    extraGroups = ["networkmanager" "wheel"];
  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.11";
}
