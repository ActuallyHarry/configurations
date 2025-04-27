###############################################
# Default Git Settings
##############################################
{ config, pkgs, ... }:
{
  programs.git.enable = true;
  programs.git.config = {
   
    init = {
      defaultBranch = "main";
    };

    user = {
      name = "ActuallyHarry";
      email = "actuallyadequate@gmail.com";
    };

    push = {
      autoSetupRemote = true;
    };

  };
 
}
