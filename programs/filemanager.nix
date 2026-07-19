{
  config,
  pkgs,
  ...
}: {
  home.packages = with pkgs; [
    file
    xdg-utils
  ];

  programs.yazi = {
    enable = true;
    enableZshIntegration = true;
    shellWrapperName = "y";

    settings = {
      mgr = {
        show_hidden = true;
      };
      preview = {
        max_width = 1000;
        max_height = 1000;
      };
      opener = {
        play = [
          {
            run = ''xdg-open "$@" '';
            desc = "Open";
          }
        ];
      };
      open = {
        rules = [
          {
            name = "*.html";
            use = "play";
          }
          {
            name = "*.svg";
            use = "play";
          }
        ];
      };
    };

    plugins = with pkgs.yaziPlugins; {
      inherit chmod;
      inherit starship;
      inherit full-border;
      inherit toggle-pane;
      inherit wl-clipboard;
    };

    initLua = ''
      require("full-border"):setup()
      require("starship"):setup()
    '';

    keymap = {
      mgr.prepend_keymap = [
        {
          on = "T";
          run = "plugin toggle-pane max-preview";
          desc = "Maximize or restore the preview pane";
        }
        {
          on = ["c" "m"];
          run = "plugin chmod";
          desc = "Chmod on selected files";
        }
        {
          on = "<C-y>";
          run = "plugin wl-clipboard";
          desc = "Copy to system Clipboard";
        }
      ];
    };
  };
}
