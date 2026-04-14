{
  config,
  pkgs,
  ...
}: {
  security.rtkit.enable = true;
  services.pulseaudio.enable = false;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    pulse.enable = true;
    jack.enable = true;
    wireplumber.enable = true;
    wireplumber.extraConfig."10-bluez" = {
      "monitor.bluez.properties" = {
        "bluez5.enable-sbc-xq" = true;
        "bluez5.enable-msbc" = true;
        "bluez5.enable-hw-volume" = true;
        # REMOVE hsp_hs and hfp_hf from roles to disable Hands-Free mode
        "bluez5.roles" = ["a2dp_sink" "a2dp_source"];
      };
      "wireplumber.settings" = {
        # Prevents the "Helpful" auto-switch to low quality
        "bluetooth.autoswitch-to-headset-profile" = false;
      };
    };
  };
}
