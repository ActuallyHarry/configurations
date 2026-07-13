{config, pkgs, ...}:
{

  virtualisation.docker.enable = true;
users.users.harry.extraGroups = [ "docker" ];

}
