{
  config,
  pkgs,
  ...
}: {
  home.packages = with pkgs; [
    (blender.override {
      config.cudaSupport = true;
      config.rocmSupport = true;
    })
  ];
}
