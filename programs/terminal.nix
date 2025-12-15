{config, pkgs, stylix, ... }:
let 
 palette = config.colorScheme.palette;
in
{
  stylix.targets.ghostty.enable = true;
  programs.ghostty = {
    enable = true;
    enableZshIntegration = true;
   
    settings = {
      window-padding-x = 14;
      window-padding-y = 14;
      background-opacity = 0.95;
      window-decoration = "none";

      font-size = 12;
      keybind = [ ];           
  
      shell-integration-features = "ssh-env,ssh-terminfo";
    };
  };


  stylix.targets.alacritty.enable = true;
  programs.alacritty = {
    enable = true;
    
  };

  stylix.targets.starship.enable =  true;
  programs.starship = {
    enable = true;
    enableZshIntegration = true;
  };

  programs.zsh = {
    enable = true;
    autosuggestion.enable = true;
  };
}
