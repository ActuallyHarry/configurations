{ config, pkgs, ... }:

{

  networking.firewall = {
   allowedTCPPorts = [ 443 ];
  };

  sops.secrets."adventurelog-env" = { 
    sopsFile = ../secrets/adventurelog.env;
    format = "dotenv";
  };



  # 1. Enable the Container Engine (Podman is recommended on NixOS)
  virtualisation.oci-containers.backend = "docker";
  virtualisation.docker.enable = true;

  systemd.services.init-adventure-network = {
    description = "Create Docker network for AdventureLog";
    after = [ "network.target" "docker.service" ];
    wantedBy = [ "multi-user.target" ];
    serviceConfig.Type = "oneshot";
    script = ''
      check=$(${pkgs.docker}/bin/docker network ls -qf name=adventure-net)
      if [ -z "$check" ]; then
        ${pkgs.docker}/bin/docker network create adventure-net
      fi
    '';
  };

  virtualisation.oci-containers.containers = {

    # --- DB ---
    "adventurelog-db" = {
      image = "postgis/postgis:16-3.5";
      # NixOS equivalent of env_file: .env
      environmentFiles = [ config.sops.secrets."adventurelog-env".path ]; 
      volumes = [ "postgres_data:/var/lib/postgresql/data/" ];
      extraOptions = ["--network=adventure-net"  "--network-alias=db" ]; # Maps 'db' to this container
    };

    # --- SERVER (Backend) ---
    "adventurelog-server" = {
      image = "ghcr.io/seanmorley15/adventurelog-backend:latest";
      dependsOn = [ "adventurelog-db" ];
      ports = [ "127.0.0.1:8016:80" ];
      environmentFiles = [ config.sops.secrets."adventurelog-env".path ];
      volumes = [ "adventurelog_media:/code/media/" ];
      extraOptions = [ 
        "--network=adventure-net"
        "--link=adventurelog-db:db" 
        "--network-alias=server"
      ];
    };

    # --- WEB (Frontend) ---
    "adventurelog-web" = {
      image = "ghcr.io/seanmorley15/adventurelog-frontend:latest";
      dependsOn = [ "adventurelog-server" ];
      ports = [ "127.0.0.1:8015:3000" ];
      environmentFiles = [ config.sops.secrets."adventurelog-env".path ];
      extraOptions = [ 
        "--network=adventure-net"
        "--link=adventurelog-server:server" 
      ];
    };
  };
  

services.nginx = {
    enable = true;

    virtualHosts."adventure.zitohouse.net" = {
      forceSSL = true;
      sslCertificate = "/var/lib/acme/home-wildcard/fullchain.pem";
      sslCertificateKey = "/var/lib/acme/home-wildcard/key.pem";

      locations."/" = {
        proxyPass = "http://127.0.0.1:8015"; # Frontend
        extraConfig = ''
      proxy_buffer_size 128k;
      proxy_buffers 4 256k;
      proxy_busy_buffers_size 256k;
      proxy_set_header X-Real-IP $remote_addr;
      proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
      proxy_set_header X-Forwarded-Proto $scheme;
      proxy_set_header Host $host;
    '';
      };
    };

    virtualHosts."adventure-api.zitohouse.net" = {
      forceSSL = true;
      sslCertificate = "/var/lib/acme/home-wildcard/fullchain.pem";
      sslCertificateKey = "/var/lib/acme/home-wildcard/key.pem";

      # 1. Handle the API requests
      locations."/" = {
        proxyPass = "http://127.0.0.1:8016"; # Backend
        extraConfig = ''
      proxy_buffer_size 128k;
      proxy_buffers 4 256k;
      proxy_busy_buffers_size 256k;
      proxy_set_header X-Real-IP $remote_addr;
      proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
      proxy_set_header X-Forwarded-Proto $scheme;
      proxy_set_header Host $host;
   '';
    };

  };
};  
users.users.nginx.extraGroups = [ "acme" ];
}
