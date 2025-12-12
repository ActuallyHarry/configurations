{ config, pkgs, ...}:
{

  networking.firewall.allowedTCPPorts = [ 443 8384 22067 22000];
  networking.firewall.allowedUDPPorts = [ 22000 ];

  sops.secrets.syncthingRelayToken = {
    sopsFile = ../secrets/syncthing.yaml;
  };

  # Private Relay
  services.syncthing.relay = {
    enable = true;
    pools = [""]; # By being empty it will be private     
    extraOptions = [
     "token=$(${pkgs.coreutils}/bin/cat ${config.sops.secrets.syncthingRelayToken.path})"
    ];
    listenAddress="192.168.10.4";
   
  };



  sops.secrets.syncthingGUIPassword = {
    sopsFile = ../secrets/syncthing.yaml;
    owner = "${config.services.syncthing.user}";
  };

  services.syncthing = {
    enable = true;
    dataDir = "/data/synced";
    guiPasswordFile = "${config.sops.secrets.syncthingGUIPassword.path}";
    openDefaultPorts = true;
    guiAddress = "192.168.10.4:8384";
    settings = {
      options = {
        listenAddresses = [ # This is the private relay
          "relay://syncthingrelay.home.actuallyadequate.net:22067/?id=VBRON2Y-NPGV4OR-MW3MXM7-TEDGGVO-IJMDUKJ-RHVS3CD-7MRLPCH-KLJI7QA"
          "tcp://0.0.0.0:22000"
        ];
        relaysEnabled = true;
        globalAnnounceEnabled = false;
        localAnnounceEnabled = true;
        natEnabled = false;
        urAccepted = -1;
      };
      gui = {
        enabled = true;
        user = "admin";
      };

      devices = {
        odyssey.id = "R4CG25Q-X25BPAA-LFDNMBV-HOJZMN7-G2RLFG5-E3YDK4J-IPA6KRM-BD6PQAS";
        nomadica.id = "HTH37O7-SPZWEER-GQIAYRA-XYQHL3W-SHH75XC-NZAMQVX-5PQC5ZI-WUQ53AD";
      };
     
      folders = {
       "synced-harry" = {
         path = "/data/synced/harry";
         devices = [ "odyssey" "nomadica"];
       };
      };

    };   
  }; 
 services.nginx.enable = true;
 services.nginx.virtualHosts."syncthing.home.actuallyharry.net" = {

    serverName="syncthing";
    serverAliases=["syncthing.home.actuallyharry.net"];

    enableACME = false; # I am managing it not nginx
    forceSSL = true;

    sslCertificate = "/var/lib/acme/home-wildcard/fullchain.pem";
    sslCertificateKey = "/var/lib/acme/home-wildcard/key.pem";

    extraConfig = ''
      client_max_body_size 525M;

      proxy_http_version 1.1;
      proxy_set_header Upgrade $http_upgrade;
      proxy_set_header Connection $connection_upgrade;

      proxy_set_header Host $host;
      proxy_set_header X-Real-IP $remote_addr;
      proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
      proxy_set_header X-Forwarded-Proto $scheme;

    '';

    locations."/" = {
      proxyPass = "http://localhost:8384";
    };

  };

}
