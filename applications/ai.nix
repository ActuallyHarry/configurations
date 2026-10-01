{
  config,
  pkgs,
  ...
}: {
  networking.firewall.allowedTCPPorts = [443];

  services.ollama = {
    enable = true;
    package = pkgs.ollama-cuda;
    loadModels = [
      "qwen3.5:9b"
    ];
    syncModels = true;
  };

  services.nginx.enable = true;
  services.nginx.virtualHosts = {
    # Sonarr Subdomain
    "cognitus.zitohouse.net" = {
      # Use the fully qualified domain name (FQDN) as the virtual host key and serverAlias
      serverName = "cognitus";
      serverAliases = ["cognitus.zitohouse.net"];

      enableACME = false; # I am managing it not nginx
      forceSSL = true;

      sslCertificate = "/var/lib/acme/home-wildcard/fullchain.pem";
      sslCertificateKey = "/var/lib/acme/home-wildcard/key.pem";

      # This location block handles all traffic for this subdomain
      locations."/" = {
        proxyPass = "http://127.0.0.1:11434";
        proxyWebsockets = true;

        extraConfig = ''
          proxy_set_header X-Forwarded-Proto $scheme;
          proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
          proxy_set_header Host $host;
        '';
      };
    };
  };

  users.users.nginx.extraGroups = ["acme"];
}
