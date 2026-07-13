{
  config,
  pkgs,
  ...
}: {
  home.packages = with pkgs; [
    termsonic
    jellyfin-web
  ];
}
