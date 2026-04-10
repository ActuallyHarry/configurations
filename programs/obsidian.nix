{
  config,
  pkgs,
  lib,
  ...
}: {
  nixpkgs.config.allowUnfreePredicate = pkg:
    builtins.elem (lib.getName pkg) [
      "obsidian"
    ];

  home.packages = with pkgs; [obsidian];

  stylix.targets.obsidian.enable = true;
  #programs.obsidian = {
  #  enable = true;
  #  vaults."Knowledge" = {
  #    target = "Synced/harry/Knowledge";
  #  };
  #};
}
