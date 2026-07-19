{ config, pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    vim
    curl
    unzip
    wget
    gnumake
  ];
}
