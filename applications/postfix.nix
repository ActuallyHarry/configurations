{config, pkgs, ... }:
{
  
  networking.firewall.allowedTCPPorts = [ 25 587 ];

  sops.secrets."postfix/sasl_passwd" = {
    owner = config.services.postfix.user;
  };

  services.postfix = {
    enable = true;
    
    relayHost = "smtp.gmail.com";
    relayPort = 587;

    config = {

     mynetworks = "127.0.0.0/8 192.168.1.0/24 192.168.10.0/24 192.168.20.0/24 192.168.90/24";

     inet_interfaces = "all";
     inet_protocols = "ipv4";
     
     # Outgoing Mail  
     smtp_use_tls = "yes";
     smtp_sasl_auth_enable = "yes";
     smtp_sasl_security_options = "";
     smtp_sasl_password_maps = "texthash:${config.sops.secrets."postfix/sasl_passwd".path}";

     # Incoming Mail
     smtpd_use_tls = "yes";
     smtpd_tls_cert_file = "/var/lib/acme/home-wildcard/cert.pem";
     smtpd_tls_key_file = "/var/lib/acme/home-wildcard/key.pem"; 


    };

    masterConfig = {
      submission = {
        type = "inet";
        command = "smtpd";
        private = false;
        chroot = false;
      };
    };
   
  };
}
