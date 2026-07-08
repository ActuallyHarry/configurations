{config, pkgs, ...}:
{






sops.secrets."ugreen-smb-creds" = {
   sopsFile = ../secrets/ugreen-smb-creds;
   format = "binary";
};

sops.secrets."ugreen-syncthing-creds" = {
   sopsFile = ../secrets/ugreen-syncthing-creds;
   format = "binary";
};

environment.systemPackages = [ pkgs.nfs-utils ];

# 2. Configure the NFS mount on the Host
fileSystems."/mnt/host-media" = {
  # NFS format: "IP:/path/on/nas"
  device = "192.168.0.144:/volume2/media"; 
  fsType = "nfs";
  options = [
    "nodev"
    "nofail"
    "noatime"
    "rw"
    
    # Prevents the host from freezing if the NAS goes offline
    "soft"          
    "intr"          
    
    # Force NFS version  (Ugreen supports this natively)
    "nfsvers=3"     
  ];
};

fileSystems."/mnt/host-syncthing" = {
  # NFS format: "IP:/path/on/nas"
  device = "192.168.0.144:/volume1/syncthing";
  fsType = "nfs";
  options = [
    "nodev"
    "nofail"
    "noatime"
    "rw"

    # Prevents the host from freezing if the NAS goes offline
    "soft"
    "intr"

    # Force NFS version  (Ugreen supports this natively)
    "nfsvers=3"
  ];
};
}
