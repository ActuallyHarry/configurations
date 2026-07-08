{ config, pkgs, ...}:
{
  # 1. FIX: Added port 80 so the Nginx forceSSL redirect actually connects
  networking.firewall.allowedTCPPorts = [ 80 443 8384 22067 22000 ];
  networking.firewall.allowedUDPPorts = [ 22000 ];

  sops.secrets.syncthingRelayToken = {
    sopsFile = ../secrets/syncthing.yaml;
  };

  # Private Relay
  services.syncthing.relay = {
    enable = true;
    pools = [""]; 
    extraOptions = [
     "token=$(${pkgs.coreutils}/bin/cat ${config.sops.secrets.syncthingRelayToken.path})"
    ];
    listenAddress="192.168.10.6";
  };

  sops.secrets.syncthingGUIPassword = {
    sopsFile = ../secrets/syncthing.yaml;
    owner = "${config.services.syncthing.user}";
  };

  services.syncthing = {
    enable = true;
    dataDir = "/mnt/syncthing";
    guiPasswordFile = "${config.sops.secrets.syncthingGUIPassword.path}";
    openDefaultPorts = true;
    guiAddress = "127.0.0.1:8384";
    
    settings = {
      options = {
        listenAddresses = [ 
          "relay://syncthingrelay.zitohouse.net:22067/?id=CXIK7PV-DXIKW2D-QHRY7GZ-DF4HTGE-UX4QTDF-BUZB5LS-M3QPFNL-NQ2ZKAZ"
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
        # 2. FIX: Tells Syncthing not to block the reverse proxy domain
        insecureSkipHostcheck = true; 
      };

      devices = {
        odyssey.id = "R4CG25Q-X25BPAA-LFDNMBV-HOJZMN7-G2RLFG5-E3YDK4J-IPA6KRM-BD6PQAS";
        nomadica.id = "HTH37O7-SPZWEER-GQIAYRA-XYQHL3W-SHH75XC-NZAMQVX-5PQC5ZI-WUQ53AD";
        praetorian.id = "JN73VRQ-HN42G3K-R5ISK5X-OATIROP-CHG26QZ-EZ2CFON-U5OYYM4-RKHRKAG";
      };

      folders = {
       "synced-harry" = {
         path = "/mnt/syncthing/harry";
         devices = [ "odyssey" "nomadica" "praetorian"];
       };
      };
    };
  };
  
  users.users.syncthing.extraGroups = [ "media" ];

  services.nginx = {
    enable = true;
    
    # 3. FIX: Lets NixOS automatically manage standard proxy headers (X-Forwarded-For, etc.)
    recommendedProxySettings = true;

    virtualHosts."syncthing.zitohouse.net" = {
      serverName = "syncthing";
      serverAliases = ["syncthing.zitohouse.net"];

      enableACME = false; 
      forceSSL = true;

      sslCertificate = "/var/lib/acme/home-wildcard/fullchain.pem";
      sslCertificateKey = "/var/lib/acme/home-wildcard/key.pem";

      # 4. FIX: Removed the manual header variables, keeping just the body size config
      extraConfig = ''
        client_max_body_size 525M;
      '';

      locations."/" = {
        # 5. FIX: Match Syncthing's IPv4 guiAddress exactly to prevent IPv6 loopback errors
        proxyPass = "http://127.0.0.1:8384";
        
        # 6. FIX: Tells NixOS to inject the proper Connection/Upgrade headers for Syncthing's WebUI
        proxyWebsockets = true;
      };
    };
  };

  users.users.nginx.extraGroups = [ "acme" ];
}
