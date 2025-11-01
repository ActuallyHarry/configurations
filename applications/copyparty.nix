{config, pkgs, inputs, ...}:
{
   imports = [
    inputs.copyparty.nixosModules.default
   ];
 
   nixpkgs.overlays = [ inputs.copyparty.overlays.default ];

   networking.firewall.allowedTCPPorts = [ 443 ];

   sops.secrets."copyparty/jellyfin" = {
     sopsFile = ../secrets/copyparty.yaml;
     owner = config.services.copyparty.user; 
   };

   sops.secrets."copyparty/noxium" = {
     sopsFile = ../secrets/copyparty.yaml;
     owner = config.services.copyparty.user; 
   };

   services.copyparty = {
      enable = true;
      user = "copyparty";
      group = "copyparty";

      settings = {
        i = "127.0.0.1";
        p = ["3923"];
        rproxy = 1;
      };

      accounts = {
         jellyfin.passwordFile = config.sops.secrets."copyparty/jellyfin".path;
         noxium.passwordFile = config.sops.secrets."copyparty/noxium".path;
      };

      volumes = {
   
        "/media" = {
           path="/data/media";
           access= {
              r = ["jellyfin"];
              rw = ["noxium"];
           };
        };
      };
      
   };

  services.nginx.enable = true;
  services.nginx.virtualHosts."horreum.home.actuallyadequate.net" = {

    serverName="horreum";
    serverAliases=["horreum.home.actuallyadequate.net" "horreum.actuallyadequate.net"];
    enableACME = false; # I am managing it not nginx
    forceSSL = true;

    sslCertificate = "/var/lib/acme/home-wildcard/fullchain.pem";
    sslCertificateKey = "/var/lib/acme/home-wildcard/key.pem";

    extraConfig = ''
       add_header Strict-Tansport-Security "max-age=6307200" always;
       real_ip_header CF-Connecting-IP;
       set_real_ip_from 192.168.10.4;
    '';

    locations."/" = {
      proxyPass = "https://127.0.0.1:3923";
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
