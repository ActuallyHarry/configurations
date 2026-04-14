{
  config,
  pkgs,
  ...
}: {
  # Steam
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = true;
    localNetworkGameTransfers.openFirewall = true;
  };

  # Discord
  environment.systemPackages = with pkgs; [
    discord
  ];
}
