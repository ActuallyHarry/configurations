{ config, pkgs, ... }:
{

  networking.firewall.allowedTCPPorts = [443];
  users.groups.media = {
    gid = 984;
  };

  services.sonarr = {
    enable = true;
    group="media";
  };
  
  services.radarr = {
    enable = true;
    group = "media";
  };

  services.prowlarr = {
    enable = true;
 };

 services.lidarr = {
   enable = true;
   group = "media";
 };

  services.flaresolverr.enable = true;

  sops.secrets."noxium-priv-key" = {
     sopsFile = ../secrets/noxium-priv-key;
     group = builtins.toString config.users.groups.media.name;
     format = "binary";
   };

  environment.systemPackages = [pkgs.cifs-utils];
  fileSystems."/mnt/media" = {
   device = "noxium@192.168.10.4:/data/media";
   fsType = "sshfs";
   options = [
      "nodev"
      "nofail"
      "noatime"
      "allow_other"
      "reconnect" # Highly recommended for network stability
      
      # The key option: points sshfs to the file containing the password.
      # This file will be managed by sops-nix.
      "IdentityFile=${config.sops.secrets."noxium-priv-key".path}" 
      
      "gid=${builtins.toString config.users.groups.media.gid}"
    ];
 }; 
  

  services.nginx.enable = true;
  services.nginx.virtualHosts = {

    # Sonarr Subdomain
    "sonarr.zitohouse.net" = {
      # Use the fully qualified domain name (FQDN) as the virtual host key and serverAlias
      serverName = "sonarr";
      serverAliases = ["sonarr.zitohouse.net"];

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
    "radarr.zitohouse.net" = {
      serverName = "radarr";
      serverAliases = ["radarr.zitohouse.net"];
      
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
    # Lidarr Subdomain
    "lidarr.zitohouse.net" = {
      serverName = "lidarr";
      serverAliases = ["lidarr.zitohouse.net"];
      
      enableACME = false;
      forceSSL = true;

      sslCertificate = "/var/lib/acme/home-wildcard/fullchain.pem";
      sslCertificateKey = "/var/lib/acme/home-wildcard/key.pem";

      locations."/" = {
        proxyPass = "http://127.0.0.1:8686";
        proxyWebsockets = true;

        extraConfig = ''
          proxy_set_header X-Forwarded-Proto $scheme;
          proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
          proxy_set_header Host $host;
        '';
      };
    };

    # Prowlarr Subdomain
    "prowlarr.zitohouse.net" = {
      serverName = "prowlarr";
      serverAliases = ["prowlarr.zitohouse.net"];
      
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
