#########################################################################
# Settings for Experimental Features
########################################################################

{config, pkg, ...}:
{
  # Enable Flakes
  nix.settings.experimental-features = ["nix-command" "flakes"];
}
