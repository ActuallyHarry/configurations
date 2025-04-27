##########################################################
# Defines Default User
##########################################################

{ config, pkgs, ... }:
{
  users.users.admin = {
    isNormalUser = true;
    description = "admin";
    extraGroups = [ "networkmanager" "wheel" ];
    # Password set with passwd imperativly
  };
}
