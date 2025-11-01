{config, pkgs, ...}:
{
  networking.firewall.allowedTCPPorts = [ 443 ];  

  services.jellyfin = {
      enable = true;
      cacheDir = "/jellyfin/cache";
      dataDir = "/jellyfin/data";
  };

  services.jellyseerr = {
      enable = true;
  };


  sops.secrets."rclone.ini" = {
    sopsFile = ../secrets/rclone.ini;
    format = "ini";
    path = "/var/lib/rclone.ini";
  };

  # file mounts
  environment.systemPackages = [pkgs.rclone];
  fileSystems."/mnt/media" = {
    device = "horreum-media:media"; # Note: webdav remotes often don't require a path after the colon for the root
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

    # Jellyfin Subdomain
    "theatre.home.actuallyadequate.net" = {
      serverName = "theatre";
      serverAliases = ["theatre.home.actuallyadequate.net"]; # Keeping it simple with one alias

      enableACME = false; # I am managing it not nginx
      forceSSL = true;

      sslCertificate = "/var/lib/acme/home-wildcard/fullchain.pem";
      sslCertificateKey = "/var/lib/acme/home-wildcard/key.pem";

      # Shared security and IP configuration
      extraConfig = ''
        add_header Strict-Transport-Security "max-age=6307200" always;
        real_ip_header CF-Connecting-IP;
        set_real_ip_from 192.168.10.2;
      '';

      # This location block handles all traffic for this subdomain
      locations."/" = {
        proxyPass = "http://127.0.0.1:8096";
        proxyWebsockets = true;

        extraConfig = ''
          # The rewrite is no longer needed
          proxy_set_header X-Forwarded-Proto $scheme;
          proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
          proxy_set_header Host $host;
          proxy_set_header X-Real-IP $remote_addr;
          proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
          proxy_buffering off;
        '';
      };
    };


    # Jellyseerr Subdomain
    "seerr.home.actuallyadequate.net" = {
      serverName = "seerr";
      serverAliases = ["seerr.home.actuallyadequate.net"];

      enableACME = false;
      forceSSL = true;

      sslCertificate = "/var/lib/acme/home-wildcard/fullchain.pem";
      sslCertificateKey = "/var/lib/acme/home-wildcard/key.pem";

      # Shared security and IP configuration
      extraConfig = ''
        add_header Strict-Transport-Security "max-age=6307200" always;
        real_ip_header CF-Connecting-IP;
        set_real_ip_from 192.168.10.2;
      '';

      locations."/" = {
        proxyPass = "http://127.0.0.1:5055";
        proxyWebsockets = true;

        extraConfig = ''
          # The rewrite is no longer needed
          proxy_set_header X-Forwarded-Proto $scheme;
          proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
          proxy_set_header Host $host;
          proxy_set_header X-Real-IP $remote_addr;
          proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        '';
      };
    };

  };

  
  users.users.nginx.extraGroups = [ "acme" ];

}
