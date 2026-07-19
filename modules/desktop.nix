{
  config,
  pkgs,
  lib,
  ...
}: {
  services.xserver.enable = true;

  # Initial login experience
  services.greetd = {
    enable = true;
    settings.default_session.command = "${pkgs.tuigreet}/bin/tuigreet --time --cmd start-hyprland";
  };

  # fingerprint reader
  nixpkgs.config.allowUnfreePredicate = pkg:
    builtins.elem (lib.getName pkg) [
      "libfprint-2-tod1-goodix"
      "libfprint-2-tod1-goodix-0.0.6"
    ];

  services.gnome.gnome-keyring.enable = true;
  security.pam.services.hyprland.enableGnomeKeyring = true;
  security.pam.services.tuigreet.enableGnomeKeyring = true;

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
    wl-clipboard

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
