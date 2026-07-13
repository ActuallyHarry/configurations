{config, pkgs, ...}:
{
 networking.firewall.allowedTCPPorts = [ 22067 22000];
  networking.firewall.allowedUDPPorts = [ 22000 ];

}
