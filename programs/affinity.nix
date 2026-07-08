{
  config,
  pkgs,
  lib,
  affinity-nix,
  ...
}: {
  nixpkgs.overlays = [affinity-nix.overlays.default];

  home.packages = [
    (pkgs.affinity-v3.overrideAttrs (oldAttrs: {
      src = oldAttrs.src.overrideAttrs (_: {
        # This is the "got" hash from your error message
        outputHash = "sha256-xVzeLd2726tcXKzDMim2k/38z7QWlhO+3Dt6nYTbmuo=";
      });
    }))
  ];
}
