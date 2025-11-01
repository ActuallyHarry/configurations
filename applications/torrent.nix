{ config, pkgs, ...}:
{

  networking.firewall.allowedTCPPorts = [443 5000];
  
  services.qbittorrent = {
    enable = true;
    serverConfig = {
      WebUI = {
        AuthSubnetWhitelist = "192.168.0.0./16";
        AuthSubnetWhitelistEnabled = true;
      };

    };
  };

  services.nginx.enable = true;
  services.nginx.virtualHosts = {

    # Torrent Subdomain Virtual Host
    "torrent.home.actuallyadequate.net" = {
      # The key is the FQDN for the subdomain
      serverName = "torrent";
      serverAliases = ["torrent.home.actuallyadequate.net"];

      enableACME = false; # I am managing it not nginx
      forceSSL = true;

      sslCertificate = "/var/lib/acme/home-wildcard/fullchain.pem";
      sslCertificateKey = "/var/lib/acme/home-wildcard/key.pem";

      # Use the root location "/" since the entire subdomain is for this service
      locations."/" = {
        proxyPass = "http://127.0.0.1:8080";
        proxyWebsockets = true;

        # The rewrite is no longer needed since the path is stripped automatically
        # when proxying from the root location (e.g., /)
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
