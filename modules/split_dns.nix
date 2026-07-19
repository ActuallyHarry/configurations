{config, pkgs, ...}:
{
  services.dnsmasq.enable = true;

  networking.nameservers = [ "127.0.0.53" ];

  services.dnsmasq.settings = {
     server = ["/zitohouse.net/192.168.10.2" "10.0.0.242" "10.0.0.243"];
     domain-needed = true;
     no-resolv = true;
  };

}
