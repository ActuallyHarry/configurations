{config, pkgs, ...}:
{
  networking.firewall.allowedTCPPorts = [ 443  8096 ];  

  services.jellyfin = {
      enable = true;
      cacheDir = "/jellyfin/cache";
      dataDir = "/jellyfin/data";
      group = "media";
  };

  services.jellyseerr = {
      enable = true;
  };


#  sops.secrets."rclone.ini" = {
#    sopsFile = ../secrets/rclone.ini;
#    format = "ini";
#    path = "/var/lib/rclone.ini";
#  };

  # file mounts
#  environment.systemPackages = [pkgs.rclone];
#  fileSystems."/mnt/media" = {
#    device = "horreum-media:media"; # Note: webdav remotes often don't require a path after the colon for the root
#    fsType = "rclone";
#    options = [
#      "nodev"
#      "nofail"
#      "allow_other"
#      "args2env"
#      "config=/var/lib/rclone.ini"
#      "vfs-cache-mode=writes" # from rclone mount command
#      "dir-cache-time=5s"     # from rclone mount command
#    ];
#  };

users.groups.media = {
    gid = 984;
  };

sops.secrets."noxium-priv-key" = {
     sopsFile = ../secrets/noxium-priv-key;
     group = builtins.toString config.users.groups.media.name;
     format = "binary";
   };

environment.systemPackages = [pkgs.cifs-utils];
  fileSystems."/mnt/media" = {
   device = "noxium@horreum.zitohouse.net:/data/media";
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
  services.nginx.commonHttpConfig = ''
    proxy_headers_hash_max_size 1024;
    proxy_headers_hash_bucket_size 128;
  '';

  services.nginx.virtualHosts = {

    # Jellyfin Subdomain
    "theatre.zitohouse.net" = {
      serverName = "theatre";
      serverAliases = ["theatre.zitohouse.net"]; # Keeping it simple with one alias

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
    "seerr.zitohouse.net" = {
      serverName = "seerr";
      serverAliases = ["seerr.zitohouse.net"];

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
