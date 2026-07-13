{
  config,
  pkgs,
  ...
}: {
  services.syncthing = {
    enable = true;
    settings = {
      options = {
        listenAddresses = [
          # This is the private relay
          "relay://syncthingrelay.zitohouse.net:22067/?id=CXIK7PV-DXIKW2D-QHRY7GZ-DF4HTGE-UX4QTDF-BUZB5LS-M3QPFNL-NQ2ZKAZ"
          "tcp://0.0.0.0:22000"
        ];
        relaysEnabled = true;
        globalAnnounceEnabled = false;
        localAnnounceEnabled = true;
        natEnabled = false;
        urAccepted = -1;
      };
      gui = {
        enabled = true;
        user = "admin";
      };

      devices = {
        odyssey.id = "R4CG25Q-X25BPAA-LFDNMBV-HOJZMN7-G2RLFG5-E3YDK4J-IPA6KRM-BD6PQAS";
        horreum.id = "2HETBUK-QONIHSI-UT34W3X-2TG2D72-U75YHJP-LHFG36V-7QK6EWU-VPQ7WQ5";
        nomadica.id = "HTH37O7-SPZWEER-GQIAYRA-XYQHL3W-SHH75XC-NZAMQVX-5PQC5ZI-WUQ53AD";
        praxis.id = "JHBL47U-S3THV4O-Q56WANP-LELABQ7-EMEDIFK-HGOXIN2-63FAVJ4-VTXGAQA";
        praetorian.id = "JN73VRQ-HN42G3K-R5ISK5X-OATIROP-CHG26QZ-EZ2CFON-U5OYYM4-RKHRKAG";
      };
      folders = {
        "synced-harry" = {
          path = "~/Synced/harry";
          devices = ["horreum" "odyssey" "praxis" "praetorian"];
        };
      };
    };
  };
}
