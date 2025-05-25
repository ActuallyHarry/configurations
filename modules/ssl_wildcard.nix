{config, pkgs, ... }:
{

  sops.secrets."acme.env" = {
    sopsFile = ../secrets/acme.env;
    format = "dotenv";
    path = "/var/lib/acme.env";
    owner = "acme";
  };


  security.acme = {
 
    acceptTerms = true;
    defaults.email = "actuallyadequate@gmail.com";
    
    certs."home-wildcard" = {

      domain = "*.home.actuallyharry.net";
      dnsResolver = "1.1.1.1:53";
      dnsProvider = "cloudflare";
      dnsPropagationCheck  = true;
      environmentFile = "/var/lib/acme.env";
      
    }; 
  };

}
