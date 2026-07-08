{
  config,
  pkgs,
  ...
}: {
  services.ollama = {
    enable = true;
    package = pkgs.ollama-cuda;
    loadModels = [
      "gemma4:e4b"
    ];
    syncModels = true;
  };

  services.open-webui.enable = true;
  environment.systemPackages = with pkgs; [
    oterm
  ];
}
