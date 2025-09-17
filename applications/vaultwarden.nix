###########################################################
# Vaultwarden Settings
###########################################################
{ config, pkgs, ... }:
{

#  networking.firewall.enable = false;
  networking.firewall.allowedTCPPorts = [ 443 ];

  services.vaultwarden = {
    
     enable = true;

     environmentFile = "/var/lib/vaultwarden.env";

     config = {
        DOMAIN = "http://vanguard.home.actuallyharry.net";
        SIGNUPS_ALLOWED = false;
 
        ROCKET_ADDRESS = "127.0.0.1";
        ROCKET_PORT = 8222;       
     };
  };

  services.nginx.enable = true;
  services.nginx.virtualHosts."occultus.home.actuallyharry.net" = {
    enableACME = false; # I am managing it not nginx  
    forceSSL = true;
   
    sslCertificate = "/var/lib/acme/home-wildcard/fullchain.pem";
    sslCertificateKey = "/var/lib/acme/home-wildcard/key.pem"; 

    locations."/" = {
      proxyPass = "http://127.0.0.1:${toString config.services.vaultwarden.config.ROCKET_PORT}";
      proxyWebsockets = true;
    };

  };
  
  # Allow nginx to read certificate
  users.users.nginx.extraGroups = [ "acme" ];


}
