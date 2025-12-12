{config, pkgs, inputs, ...}:
let
  copypartyPkg = pkgs.copyparty.overridePythonAttrs (oldAttrs: {
    propagatedBuildInputs = (oldAttrs.propagatedBuildInputs or []) ++ [
      # List your missing dependencies here:
      pkgs.python313Packages.impacket 
    ];
  });  
in
{
   imports = [
    inputs.copyparty.nixosModules.default
   ];
 

   networking.firewall.allowedTCPPorts = [ 443 445];

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

      package = copypartyPkg;  

      settings = {
        i = "127.0.0.1";
        p = ["3923" ];
        rproxy = 1;
        e2dsa = true;
        dedup = true;
        smbw = true;
        smb-port = 3945; 
     };

      accounts = {
         jellyfin.passwordFile = config.sops.secrets."copyparty/jellyfin".path;
         noxium.passwordFile = config.sops.secrets."copyparty/noxium".path;
      };

      volumes = {
   
        "/media" = {
           path="/data/media";
           access= {
              rwmd = ["noxium" "jellyfin" ];
           };
           flags= {
             hardlinksonly=true;
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
        client_max_body_size 0;
      '';
    };

  };

  services.nginx.streamConfig = ''
    upstream copyparty_smb {
        server 127.0.0.1:3945;
    }
    
    server {
        # Listen on the standard SMB port (445)
        listen 445; 
        
        # Forward the raw TCP stream to the upstream block
        proxy_pass copyparty_smb;
    }
  '';

  users.users.nginx.extraGroups = [ "acme" ];


}
