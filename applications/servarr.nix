{ config, pkgs, ... }:
{

  networking.firewall.allowedTCPPorts = [443];
  services.sonarr = {
    enable = true;
  };
  
  services.radarr = {
    enable = true;
  };

  services.prowlarr = {
    enable = true;
 };

  services.flaresolverr.enable = true;

  sops.secrets."rclone.ini" = {
    sopsFile = ../secrets/rclone.ini;
    format = "ini";
    path = "/var/lib/rclone.ini";
  };

  environment.systemPackages = [pkgs.rclone];
  fileSystems."/mnt/media" = {
    device = "noxium-media:media"; # Note: webdav remotes often don't require a path after the colon f>
    fsType = "rclone";
    options = [
      "nodev"
      "nofail"
      "allow_other"
      "args2env"
      "config=/var/lib/rclone.ini"
      "vfs-cache-mode=writes" # from rclone mount command
      "dir-cache-time=5s"     # from rclone mount command
    ];
  }; 
  

  services.nginx.enable = true;
  services.nginx.virtualHosts = {

    # Sonarr Subdomain
    "sonarr.home.actuallyadequate.net" = {
      # Use the fully qualified domain name (FQDN) as the virtual host key and serverAlias
      serverName = "sonarr";
      serverAliases = ["sonarr.home.actuallyadequate.net"];

      enableACME = false; # I am managing it not nginx
      forceSSL = true;

      sslCertificate = "/var/lib/acme/home-wildcard/fullchain.pem";
      sslCertificateKey = "/var/lib/acme/home-wildcard/key.pem";

      # This location block handles all traffic for this subdomain
      locations."/" = {
        proxyPass = "http://127.0.0.1:8989";
        proxyWebsockets = true;

        extraConfig = ''
          proxy_set_header X-Forwarded-Proto $scheme;
          proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
          proxy_set_header Host $host;
        '';
      };
    };

    # Radarr Subdomain
    "radarr.home.actuallyadequate.net" = {
      serverName = "radarr";
      serverAliases = ["radarr.home.actuallyadequate.net"];
      
      enableACME = false;
      forceSSL = true;

      sslCertificate = "/var/lib/acme/home-wildcard/fullchain.pem";
      sslCertificateKey = "/var/lib/acme/home-wildcard/key.pem";

      locations."/" = {
        proxyPass = "http://127.0.0.1:7878";
        proxyWebsockets = true;

        extraConfig = ''
          proxy_set_header X-Forwarded-Proto $scheme;
          proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
          proxy_set_header Host $host;
        '';
      };
    };

    # Prowlarr Subdomain
    "prowlarr.home.actuallyadequate.net" = {
      serverName = "prowlarr";
      serverAliases = ["prowlarr.home.actuallyharry.net"];
      
      enableACME = false;
      forceSSL = true;

      sslCertificate = "/var/lib/acme/home-wildcard/fullchain.pem";
      sslCertificateKey = "/var/lib/acme/home-wildcard/key.pem";

      locations."/" = {
        proxyPass = "http://127.0.0.1:9696";
        proxyWebsockets = true;

        extraConfig = ''
          proxy_set_header X-Forwarded-Proto $scheme;
          proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
          proxy_set_header Host $host;
        '';
      };
    };
   };
   users.users.nginx.extraGroups = [ "acme" ];
}
