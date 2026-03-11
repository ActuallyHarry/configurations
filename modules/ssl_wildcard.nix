{config, pkgs, ... }:
{

  sops.secrets."acme.env" = {
    sopsFile = ../secrets/acme.env;
    format = "dotenv";
    owner = config.security.acme.defaults.group;
  };


  security.acme = {
 
    acceptTerms = true;
    defaults.email = "admin@zitohouse.net";
    
    certs."home-wildcard" = {

      domain = "*.zitohouse.net";
      dnsResolver = "1.1.1.1:53";
      dnsProvider = "cloudflare";
      dnsPropagationCheck  = true;
      environmentFile = "${config.sops.secrets."acme.env".path}";
    }; 
  };

}
