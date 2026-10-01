{
  config,
  pkgs,
  ...
}: {
  services.ollama = {
    enable = true;
    package = pkgs.ollama-cuda;
    loadModels = [
      "qwen3.5:9b"
    ];
    syncModels = true;
  };

  services.open-webui.enable = true;
  environment.systemPackages = with pkgs; [
    oterm
  ];
}
