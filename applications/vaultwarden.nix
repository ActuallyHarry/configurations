###########################################################
# Vaultwarden Settings
###########################################################
{ config, pkgs, ... }:
{

#  networking.firewall.enable = false;
  networking.firewall.allowedTCPPorts = [ 443 ];

  sops.secrets."vaultwarden.env" = {
    sopsFile = ../secrets/vaultwarden.env;
    format = "dotenv";
    path = "/var/lib/vaultwarden.env";
  };


  services.vaultwarden = {
    
     enable = true;

     environmentFile = "/var/lib/vaultwarden.env";

     config = {
        DOMAIN = "https://occultus.home.actuallyharry.net";
        SIGNUPS_ALLOWED = false;
 
        ROCKET_ADDRESS = "127.0.0.1";
        ROCKET_PORT = 8222;

        SSO_ENABLED = true;
        SSO_AUTHORITY = "https://auctoritas.actuallyharry.net/application/o/vaultwarden/";
        SSO_SCOPES = "openid email profile offline_access";
        SSO_ALLOW_UNKNOWN_EMAIL_VERIFICATION = false;
        SSO_CLIENT_CACHE_EXPIRATION = 0;
        SSO_ONLY = false; # Set to true to disable email+master password login and require SSO
        SSO_SIGNUPS_MATCH_EMAIL = true; # Match first SSO login to existing account by email       
     };
  };

  services.nginx.enable = true;
  services.nginx.virtualHosts."occultus.home.actuallyharry.net" = {

    serverName="occultus";
    serverAliases=["occultus.home.actuallyharry.net" "occultus.actuallyharry.net"];

    enableACME = false; # I am managing it not nginx  
    forceSSL = true;
   
    sslCertificate = "/var/lib/acme/home-wildcard/fullchain.pem";
    sslCertificateKey = "/var/lib/acme/home-wildcard/key.pem"; 

    extraConfig = ''
      client_max_body_size 525M;

    proxy_http_version 1.1;
    proxy_set_header Upgrade $http_upgrade;
    proxy_set_header Connection $connection_upgrade;

    proxy_set_header Host $host;
    proxy_set_header X-Real-IP $remote_addr;
    # If you use Cloudflare proxying, replace $remote_addr with $http_cf_connecting_ip
    # See https://developers.cloudflare.com/support/troubleshooting/restoring-visitor-ips/restoring-original-visitor-ips/#nginx-1
    # alternatively use ngx_http_realip_module
    proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
    proxy_set_header X-Forwarded-Proto $scheme;

    '';

    locations."/" = {
      proxyPass = "http://127.0.0.1:${toString config.services.vaultwarden.config.ROCKET_PORT}";
      proxyWebsockets = true;
    };

#   The below doesnt work it prevents access for cloudlfare but then the login doesnt work
#    locations."/admin/" = {
#        extraConfig = ''
#          # Block access to the admin interface from the cloudlfare tunnel
#          # Check if the CF-Connecting-IP header exists.
#          # This header is only present for requests coming through Cloudflare.
#          if ($http_cf_connecting_ip) {
#            # If the header exists, it's an external request, so block it.
#            return 403; # Forbidden
#          }
#        '';
#           
#        proxyPass="http://127.0.0.1:${toString config.services.vaultwarden.config.ROCKET_PORT}/admin/";
#        proxyWebsockets = true;    
#    };
  };
  
  # Allow nginx to read certificate
  users.users.nginx.extraGroups = [ "acme" ];


}
