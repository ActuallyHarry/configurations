{config, pkgs, nix-colors, ...}:
let
  nix-colors-lib = nix-colors.lib.contrib {inherit pkgs;};
in
{
  imports = [ nix-colors.homeManagerModules.default ];
  colorScheme = nix-colors-lib.colorSchemeFromPicture {
    path = ../resources/background.jpg;
    variant = "dark";
  };

  gtk = {
    enable = true;
    theme = {
      name =  "everforest";
      package = pkgs.gnome-themes-extra;
    };
  };
}
