{ config, pkgs, ...}:
{
  programs.zoxide = {
    enable = true;
    enableZshIntegration = true;
    options = ["--cmd cd"];
  };

  programs.eza = {
    enable = true;
    enableZshIntegration = true;  
  };

  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
  };

  programs.ripgrep = {
    enable = true;
  };

  programs.fd = {
    enable = true;
  };

  programs.bat = {
    enable = true;
  };

  home.shellAliases = {
    cat = "bat";
  };


  home.file = {
    ".local/share/show-keybindings" = {
      source = ../resources/show-keybindings;
    };
  };
}
