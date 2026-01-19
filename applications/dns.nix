###############################################################
# DNS Server Settings
###############################################################
{ config, pkgs, ... }:
let

  homedn = "zitohouse.net";

in {

  # Required Programs
  environment.systemPackages = with pkgs; [
    dig
    bind
  ];

  # Open Firewall port
  networking.firewall.allowedTCPPorts = [ 53 853];
  networking.firewall.allowedUDPPorts = [ 53 ];

  # Settings for Bind Service
  services.bind = {
    enable = true;

    forwarders = ["192.168.0.1"];

    cacheNetworks = [
      "127.0.0.0/24"
      "::1/128"
      "192.168.0.0/16"
    ];

    extraConfig = ''
      tls local-tls {
        cert-file "/var/lib/acme/home-wildcard/fullchain.pem";
        key-file "/var/lib/acme/home-wildcard/key.pem";
      };
    '';

    extraOptions = ''
        response-policy { zone "rpz.zitohouse.net"; };
        listen-on port 853 tls local-tls { any; };
        listen-on-v6 port 853 tls local-tls { any; };
    '';
    zones = [ 
       {
        name = "rpz.${homedn}";
        allowQuery = ["any"];
        file = "/etc/bind/zones/rpz.${homedn}.zone";
        master = true;
       }
    ];
  };

  users.users.named.extraGroups = ["acme"];

  # Zone Files
  system.activationScripts.bind-zones.text = ''
    mkdir -p /etc/bind/zones
    chown -R named /etc/bind/
  '';  

  # Home Domain Zone File
  environment.etc."bind/zones/rpz.${homedn}.zone" = {
    enable = true;
    user = "named";
    group = "named";
    mode = "0644";
    text = ''
$TTL 60
@ IN SOA sentinel.zitohouse.net. admin.zitohouse.net. (
      2026011806 ; serial
      21600      ; refresh
      3600       ; retry
      604800     ; expire
      86400      ; minimum
)
@ IN NS localhost.

wayfinder.zitohouse.net      A 192.168.0.1

centurion.zitohouse.net      A 192.168.90.253
auxilium.zitohouse.net       A 192.168.90.252
facultas.zitohouse.net       A 192.168.90.251

sentinel.zitohouse.net       A 192.168.10.2
epistula.zitohouse.net       A 192.168.10.2

horreum.zitohouse.net        A 192.168.10.4
syncthingrelay.zitohouse.net A 192.168.10.4
syncthing.zitohouse.net      A 192.168.10.4

automaton.zitohouse.net      A 192.168.10.5

spectaculum.zitohouse.net    A 192.168.10.7
theatre.zitohouse.net        A 192.168.10.7
seerr.zitohouse.net          A 192.168.10.7

vanguard.zitohouse.net       A 192.168.10.3
occultus.zitohouse.net       A 192.168.10.3
auctoritas.zitohouse.net     A 192.168.10.3

noxium.zitohouse.net         A 192.168.40.99
radarr.zitohouse.net         A 192.168.40.99
sonarr.zitohouse.net         A 192.168.40.99
lidarr.zitohouse.net         A 192.168.40.99
prowlarr.zitohouse.net       A 192.168.40.99
torrent.zitohouse.net        A 192.168.40.99
usenet.zitohouse.net         A 192.168.40.99

labratorium.zitohouse.net    A 192.168.30.254
    '';
  };
}
