{ config, pkgs, ... }:
{

  services.xserver.enable = true;

  # Initial login experience
  services.greetd = {
    enable = true;
    settings.default_session.command = "${pkgs.greetd.tuigreet}/bin/tuigreet --time --cmd Hyprland";
  };


  programs.hyprland = {
    enable = true;
    # package = inputs.hyprland.packages.${pkgs.system}.hyprland;
   # package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
    portalPackage = pkgs.xdg-desktop-portal-hyprland; # Use stable nixpkgs version to fix Qt version mismatch
    withUWSM = true;
  };


  environment.systemPackages = with pkgs; [
    # Desktop Packages
    libnotify
    nautilus
    kitty

    # Hyprland Packages
    hyprshot
    hyprpicker
    hyprsunset
    brightnessctl
    pamixer
    playerctl
    gnome-themes-extra
    pavucontrol
  ];

}
