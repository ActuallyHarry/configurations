{ config, pkgs, ... }:
{
  services.navidrome = {
	enable = true;
        settings = {
           MusicFolder = "/mnt/media/music";
        };
  };

  services.nginx.enable = true;

  services.nginx.virtualHosts = {

    # Nvi drome  Subdomain
    "harmonia.zitohouse.net" = {
      serverName = "harmonia";
      serverAliases = ["harmonia.zitohouse.net"]; # Keeping it simple with one alias

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
        proxyPass = "http://127.0.0.1:4533";
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
  };


  users.users.nginx.extraGroups = [ "acme" ];

}

