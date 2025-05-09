###############################################################
# DNS Server Settings
###############################################################
{ config, pkgs, ... }:
let

  homedn = "home.actuallyharry.net";

in {

  # Required Programs
  environment.systemPackages = with pkgs; [
    dig
    bind
  ];

  # Open Firewall port
  networking.firewall.allowedTCPPorts = [ 53 ];
  networking.firewall.allowedUDPPorts = [ 53 ];
  # Settings for Bind Service
  services.bind = {
    enable = true;

    forwarders = ["192.168.1.1"];

    cacheNetworks = [
      "127.0.0.0/24"
      "::1/128"
      "192.168.0.0/16"
    ];

    zones = [ 
       {
        name = "${homedn}";
        allowQuery = ["any"];
        file = "/etc/bind/zones/${homedn}.zone";
        master = true;
       }
    ];
  };


  # Zone Files
  system.activationScripts.bind-zones.text = ''
    mkdir -p /etc/bind/zones
    chown -R named /etc/bind/
  '';  

  # Home Domain Zone File
  environment.etc."bind/zones/${homedn}.zone" = {
    enable = true;
    user = "named";
    group = "named";
    mode = "0644";
    text = ''
      $ORIGIN .
      $TTL 86400 ; 1 day
      ${homedn} IN SOA sentinel.${homedn}. admin.${homedn}. (
                                      2001062504 ; serial
                                      21600      ; refresh (6 hours)
                                      3600       ; retry (1 hour)
                                      604800     ; expire (1 week)
                                      86400      ; minimum (1 day)
                                     )

                              NS      sentinel.${homedn}.
      $ORIGIN ${homedn}.
      $TTL 3600               ; 1 hour        

      wayfinder		A	192.168.1.1      

      centurion		A	192.168.1.253
      auxilium		A	192.168.1.252
      facultas          A       192.168.1.251

      sentinel          A       192.168.1.2
      vanguard          A       192.168.1.3
      horreum           A       192.168.1.4
      automaton         A       192.168.1.5
      theatre           A       192.168.1.11

      noxium            A       192.168.1.99
      
      labratorium       A       192.168.1.254
      
    '';
  };
}
