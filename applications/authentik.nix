{config, pkgs, ...}:
{

  networking.firewall.allowedTCPPorts = [ 443 ];

  sops.secrets."authentik.env" = {
    sopsFile = ../secrets/authentik.env;
    format = "dotenv";
    path = "/var/lib/authentik.env";
  };

  sops.secrets."geoip-license-key" = {
    sopsFile = ../secrets/geoip.yaml;
    key = "authentik-key";
  };

  services.geoipupdate = {
     enable = true;
     settings = {
       DatabaseDirectory = "/var/lib/geoip/authentik";
       AccountID = 1243700;
       LicenseKey = {_secret = config.sops.secrets.geoip-license-key.path; };
       EditionIDs = [
  	"GeoLite2-ASN"
  	"GeoLite2-City"
  	"GeoLite2-Country"
       ];
     };
  };

  services.authentik = {
    enable = true;
    
    environmentFile = "/var/lib/authentik.env";
    
    settings.email = {
        host = "epistula.zitohouse.net";
        port = 587;
        username = "Auctoritas";
        use_tls = true;
        use_ssl = false;
        from = "admin@zitohouse.net";
      };


    settings.listen = {
      listen_debug = "127.0.0.1:9900";
      listen_debug_py = "127.0.0.1:9901";
      listen_http = "127.0.0.1:9000";
      listen_https = "127.0.0.1:9443";
      listen_ldap = "127.0.0.1:3389";
      listen_ldaps = "127.0.0.1:6636";
      listen_radius = "127.0.0.1:1812";
      listen_metrics = "127.0.0.1:9300";
    };
    
  };

  systemd.tmpfiles.rules = [
    "L+ /geoip - - - - /var/lib/geoip/authentik"
  ];


  services.nginx.enable = true;
  services.nginx.virtualHosts."auctoritas.zitohouse.net" = {

    serverName="auctoritas";
    serverAliases=["auctoritas.zitohouse.net"];
    enableACME = false; # I am managing it not nginx
    forceSSL = true;

    sslCertificate = "/var/lib/acme/home-wildcard/fullchain.pem";
    sslCertificateKey = "/var/lib/acme/home-wildcard/key.pem";

    extraConfig = ''
       add_header Strict-Tansport-Security "max-age=6307200" always;
       real_ip_header CF-Connecting-IP;
       set_real_ip_from 192.168.10.2;
    '';

    locations."/" = {
      proxyPass = "https://127.0.0.1:9443";
      proxyWebsockets = true;

      extraConfig = ''
        proxy_set_header X-Forwarded-Proto $scheme;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header Host $host;
      '';
    };

  };

  users.users.nginx.extraGroups = [ "acme" ];


}
