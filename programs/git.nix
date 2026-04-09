{
  config,
  pkgs,
  ...
}: {
  programs.git = {
    enable = true;
    settings = {
      # This tells Git exactly which key to use for all SSH operations
      core.sshCommand = "ssh -i ~/.ssh/id_harry -F /dev/null";
    };
    signing.format = "openpgp";
  };
}
