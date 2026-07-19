{ config, pkgs, ... }:

{
  # 1. Immich Service Config
  services.immich = {
    enable = true;
    port = 2283;
    
    # We force Immich to listen on IPv4 loopback so Nginx 
    # can reliably talk to 127.0.0.1
    host = "127.0.0.1"; 

    # Point to your existing media folder to preserve all your pictures/metadata
    mediaLocation = "/mnt/media/immich"; 

    # Fixes the 'externalDomain' constraint error we hit earlier
    settings.server.externalDomain = "https://visus.zitohouse.net";
  };

  # 2. Nginx Reverse Proxy Config (with large file support for uploads)
  services.nginx = {
    enable = true;
    virtualHosts."visus.zitohouse.net" = {
      # Add ACME/SSL settings here if you use them, e.g.:
       forceSSL = true;
       enableACME = true;

sslCertificate = "/var/lib/acme/home-wildcard/fullchain.pem";
      sslCertificateKey = "/var/lib/acme/home-wildcard/key.pem";

      locations."/" = {
        # Proxy to local Immich instance
        proxyPass = "http://127.0.0.1:2283"; 
        proxyWebsockets = true;
        recommendedProxySettings = true;

        # Fixes the "too large body" error by allowing massive 50GB file uploads
        extraConfig = ''
          client_max_body_size 50G;
          proxy_read_timeout 600s;
          proxy_send_timeout 600s;
          send_timeout 600s;
        '';
      };
    };
  };

  users.users.nginx.extraGroups = [ "acme" ];
  # 3. Open Firewall for Nginx (If you decided to stop using Cloudflare Tunnel)
  networking.firewall.allowedTCPPorts = [ 80 443 ];
}
