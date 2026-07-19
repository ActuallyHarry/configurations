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
          "relay://syncthingrelay.home.actuallyadequate.net:22067/?id=VBRON2Y-NPGV4OR-MW3MXM7-TEDGGVO-IJMDUKJ-RHVS3CD-7MRLPCH-KLJI7QA"
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
      };
      folders = {
        "synced-harry" = {
          path = "~/Synced/harry";
          devices = ["horreum" "odyssey"];
        };
      };
    };
  };
}
