{config, pkgs, ...}:
{

  networking.firewall.allowedTCPPorts = [ 443 ];

  environment.systemPackages = with pkgs; [
    docker
  ];

  virtualisation.docker.enable = true;

  sops.secrets."authentik.env" = {
    sopsFile = ../../secrets/authentik.env;
    format = "dotenv";
    path = "/var/lib/authentik.env";
    restartUnits = [ "authentik.service" ];
  };


  systemd.tmpfiles.rules = [
    "d /tmp/authentik 0755 root root -"
  ];


  systemd.services.authentik = {
   enable = true;

   description = "Authentik Identity Provider";

   after = ["docker.service"];
   wants = ["docker.service"];
   wantedBy = ["multi-user.target"];
   
   serviceConfig = {
      WorkingDirectory = "/tmp/authentik";
   };
   
   path = [pkgs.docker];

   script = ''
      set -a
      source ${config.sops.secrets."authentik.env".path}
      set +a
      cp /etc/nixos/configurations/applications/authentik/docker-compose.yml docker-compose.yml
      docker compose -f docker-compose.yml up  --remove-orphans
   '';
   


  };

  services.nginx.enable = true;
  services.nginx.virtualHosts."auctoritas.home.actuallyharry.net" = {
    enableACME = false; # I am managing it not nginx
    forceSSL = true;

    sslCertificate = "/var/lib/acme/home-wildcard/fullchain.pem";
    sslCertificateKey = "/var/lib/acme/home-wildcard/key.pem";

    extraConfig = ''
       add_header Strict-Tansport-Security "max-age=6307200" always;
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
