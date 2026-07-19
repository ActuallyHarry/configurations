{
  config,
  pkgs,
  ...
}: {
  home.username = "harry";
  home.homeDirectory = "/home/harry";

  imports = [
    # ./neovim/neovim.nix
    ../../programs/hyprland.nix
    ../../programs/terminal.nix
    ../../programs/theme.nix
    ../../programs/core.nix
    ../../programs/wofi.nix
    ../../programs/waybar.nix
    ../../programs/mako.nix
    ../../programs/btop.nix
    ../../programs/browser.nix
    ../../programs/neovim.nix
    ../../programs/syncthing.nix
    ../../programs/filemanager.nix
    ../../programs/obsidian.nix
    ../../programs/git.nix
    ../../programs/email.nix
    ../../programs/password_manager.nix
  ];

  #  home.packages = with pkgs; [
  #    starship
  #    obsidian
  #    bitwarden-desktop
  #  ];

  #  home.file = {
  #    ".gitconfig" = {
  #      source = git/gitconfig;
  #    };
  #    ".config/hypr/hyprland.conf" = {
  #      source = hyprland/hyprland.conf;
  #    };
  #        ".config/hypr/start.sh" = {
  #                source = hyprland/start.sh;
  #        };
  #        ".bashrc" = {
  #          source = bash/bashrc;
  #        };
  #  };
  programs.home-manager.enable = true;
  home.stateVersion = "24.11";
}
