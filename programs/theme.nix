{
  config,
  pkgs,
  stylix,
  ...
}: {
  imports = [
    stylix.homeModules.stylix
  ];

  stylix.enable = true;
  stylix.image = ../resources/backgrounds/background1;
  stylix.polarity = "dark";
  stylix.fonts = {
    serif = config.stylix.fonts.monospace;
    sansSerif = config.stylix.fonts.monospace;
    emoji = config.stylix.fonts.monospace;
  };
  stylix.autoEnable = false;
  stylix.targets.gtk.enable = true;
}
