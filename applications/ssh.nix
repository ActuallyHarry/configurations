########################################
# SSH Settings
########################################
{ config, pkgs, ... }:
{
  services.openssh = {
    enable = true;
    
  };
}
