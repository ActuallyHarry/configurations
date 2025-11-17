{ config, lib, pkgs, ... }:

{

  # Simply install just the packages
  environment.packages = with pkgs; [
    # User-facing stuff that you really really want to have
    vim # or some other editor, e.g. nano or neovim
    git
    openssh
    zsh
    starship
    nerdfonts
    gnugrep 
 # Some common stuff that people expect to have
    #procps
    #killall
    #diffutils
    #findutils
    #utillinux
    #tzdata
    #hostname
    #man
    #gnugrep
    #gnupg
    #gnused
    #gnutar
    #bzip2
    #gzip
    #xz
    #zip
    #unzip
  ];

terminal.font = "${pkgs.nerdfonts}/share/fonts/truetype/NerdFonts/ZedMonoNerdFont-Regular.ttf";

home-manager.config = {
   programs.starship = {
     enable = true;
     enableBashIntegration= true;
     enableZshIntegration = true;
   };

   home.file.".zshrc".text = ''
      eval "$(starship init zsh)"
  '';

  home.stateVersion = "24.05";
};


#  user.shell = pkgs.zsh;
  # Backup etc files instead of failing to activate generation if a file already exists in /etc
  environment.etcBackupExtension = ".bak";

  user.shell = "${pkgs.zsh}/bin/zsh";

  # Read the changelog before changing this value

  system.stateVersion = "24.05";
  # Set up nix for flakes
  nix.extraOptions = ''
    experimental-features = nix-command flakes
  '';

  # Set your time zone
  #time.timeZone = "Europe/Berlin";
}
