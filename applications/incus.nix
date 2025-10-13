{config, pkgs, lib, ...}:
let
  cfg = config.homeIncus;
in 
{
  options.homeIncus = {
    hostname = lib.mkOption {
       type = lib.types.str;
       description = "Hostname of the Hypervisor";
    };
    ipv4 = lib.mkOption {
      type = lib.types.str;
      description = "IP of the hypervisor";
    };
  };

  # This option ensures that dm-snapshot and dm-thin-pool are included 
  # in the initrd, which is necessary for LVM thin provisioning to work 
  # when LVM is managed early in the boot process.
  config.boot.initrd.kernelModules = [ 
    "dm-snapshot" 
    "dm-thin-pool" 
  ];

  # This option is necessary to ensure the thin-provisioning-tools 
  # binaries (like thin_check, which LVM uses) are correctly patched 
  # and accessible for LVM operations.
  config.services.lvm.boot.thin.enable = true;

  config.virtualisation.incus.enable = true;
  config.virtualisation.incus.ui.enable = true;
  config.virtualisation.incus.preseed = {
     config = {
       "core.https_address" = "0.0.0.0:7443";
       "cluster.https_address" = cfg.ipv4;
    };
  };



  config.networking.nftables.enable = true;

  config.users.users.admin.extraGroups = ["incus-admin"];

  config.environment.systemPackages = with pkgs; [
    lvm2
    thin-provisioning-tools
  ];

  config.networking.firewall.allowedTCPPorts = [ 443 8443 7443 53 67 ];

  config.services.nginx.enable = true;
  config.services.nginx.virtualHosts."${cfg.hostname}.home.actuallyharry.net" = {

    serverName=cfg.hostname;
    serverAliases=["${cfg.hostname}.home.actuallyharry.net"];
    enableACME = false; # I am managing it not nginx
    forceSSL = true;

    sslCertificate = "/var/lib/acme/home-wildcard/fullchain.pem";
    sslCertificateKey = "/var/lib/acme/home-wildcard/key.pem";

    extraConfig = ''
       add_header Strict-Tansport-Security "max-age=6307200" always;
    '';

    locations."/" = {
      proxyPass = "https://127.0.0.1:8443";
      proxyWebsockets = true;

      extraConfig = ''
        proxy_set_header X-Forwarded-Proto $scheme;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header Host $host;
      '';
    };

  };

  config.users.users.nginx.extraGroups = [ "acme" ];

}
