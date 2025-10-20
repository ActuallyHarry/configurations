{config, pkgs, ... }:
{
  
  networking.firewall.allowedTCPPorts = [ 25 587 ];

  sops.secrets."postfix/sasl_passwd" = {
    owner = config.services.postfix.user;
  };

  services.postfix = {
    enable = true;

    settings.main = {
       relayHost = ["smtp.gmail.com:587"];    
       mynetworks = ["127.0.0.0/8" "192.168.1.0/24" "192.168.10.0/24" "192.168.20.0/24" "192.168.90/24"];
   
    };
    config = {
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
