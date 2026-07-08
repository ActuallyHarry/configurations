{...}: {
  services.sunshine = {
    enable = true;
    autoStart = true;
    capSysAdmin = false;
    openFirewall = true;

    settings = {
      sunshine_name = "praetorian";
      global_prep_cmd = builtins.toJSON [
        {
          do = "hyprctl keyword monitor \"HDMI-A-1, disable\"";
          undo = "hyprctl keyword monitor \"HDMI-A-1, preferred, auto, 1\"";
        }
      ];
    };

    applications = {
      env = {
        PATH = "$(PATH):$(HOME)/.local/bin";
      };
      apps = [
        {
          name = "Desktop";
          image-path = "desktop.png";
        }
        {
          name = "Steam Big Picture";
          image-path = "steam.png";
          detached = ["setsid steam steam://open/bigpicture"];
          prep-cmd = [
            {
              do = "";
              undo = "setsid steam steam://close/bigpicture";
            }
          ];
        }
      ];
    };
  };
}
