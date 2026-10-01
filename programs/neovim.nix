{
  config,
  pkgs,
  lib,
  nvf,
  ...
}: {
  imports = [nvf.homeManagerModules.default];

  stylix.targets.nvf.enable = true;

  programs.nvf = {
    enable = true;
    settings.vim = {
      vimAlias = true;
      globals = {
        mapleader = " ";
        maplocalleader = " ";
      };
      options = {
        expandtab = true;
        tabstop = 2;
        shiftwidth = 2;
        softtabstop = 2;
      };

      # Core Utilities

      startPlugins = with pkgs.vimPlugins; [
        plenary-nvim
      ];

      statusline.lualine.enable = true;

      tabline.nvimBufferline = {
        enable = true;
      };

      filetree.neo-tree = {
        enable = true;
        setupOpts.filesystem.filtered_items.visible = true;
      };
      telescope = {
        enable = true;
      };
      terminal.toggleterm = {
        enable = true;

        lazygit = {
          enable = true;
          direction = "float";
        };
      };
      binds.whichKey.enable = true;

      git = {
        enable = false;
      };

      clipboard = {
        enable = true;
        providers.wl-copy.enable = true;
        registers = "unnamedplus";
      };

      # Language Settings
      lsp = {
        enable = true;
        formatOnSave = true;
        inlayHints.enable = true;
        lightbulb.enable = true;
        lspkind.enable = true;
      };
      languages = {
        enableTreesitter = true;
        enableFormat = true;
        enableDAP = true;

        nix.enable = true;
        lua.enable = true;
        bash.enable = true;
        markdown.enable = true;
      };

      # Code Assistance
      autocomplete.blink-cmp = {
        enable = true;
        setupOpts = {
          signature.enabled = true;
        };
      };

      assistant.codecompanion-nvim = {
        enable = true;
        setupOpts = {
          interactions = {
            chat.adapter = "ollama";
            inline.adapter = "ollama";
            agent.adapter = "ollama";
          };
          adapters = lib.mkLuaInline ''
            {
                     ollama = function()
                       return require("codecompanion.adapters").extend("ollama", {
                         env = {
                           url = "https://cognitus.zitohouse.net:443",
                         },
                         schema = {
                           model = {
                             default = "qwen3.5:9b",
                           },

                           num_ctx = {
                             default = 16384,
                           },
                         },
                       })
                       end,
             }
          '';
        };
      };

      # Keymaps
      keymaps = [
        # Navigation and Finding
        {
          key = "<leader>e";
          mode = "n";
          action = ":Neotree toggle<CR>";
          desc = "Toggle Explorer";
        }
        {
          key = "<leader>ff";
          mode = "n";
          action = ":Telescope find_files<CR>";
          desc = "Find Files";
        }
        {
          key = "<leader>fw";
          mode = "n";
          action = ":Telescope live_grep<CR>";
          desc = "Live Grep (Words)";
        }
        {
          key = "<leader>fb";
          mode = "n";
          action = ":Telescope buffers<CR>";
          desc = "Find Buffers";
        }
        {
          key = "<leader>fh";
          mode = "n";
          action = ":Telescope help_tags<CR>";
          desc = "Help Tags";
        }
        {
          key = "<leader>bn";
          mode = "n";
          action = ":bnext<CR>";
          desc = "Next Buffer";
        }
        {
          key = "<leader>bp";
          mode = "n";
          action = ":bprevious<CR>";
          desc = "Previous Buffer";
        }
        {
          key = "<leader>br";
          mode = "n";
          action = ":bdelete<CR>";
          desc = "Close Current Buffer";
        }

        # Terminal & Git
        {
          key = "<leader>t";
          mode = "n";
          action = ":ToggleTerm<CR>";
          desc = "Toggle Term Floating Terminal";
        }
        {
          key = "<Esc>";
          mode = "t";
          action = "<C-\\><C-n>";
          desc = "Exit Terminal Mode";
        }
        {
          key = "<leader>th";
          mode = "n";
          action = ":ToggleTerm direction=horizontal<CR>";
          desc = "Toggle Horizontal Terminal";
        }
        {
          key = "<leader>g";
          mode = "n";
          action = ":ToggleTerm cmd=lazygit<CR>";
          desc = "Launch Lazygit";
        }
        # Code Companion
        # CodeCompanion Keymaps
        {
          key = "<leader>ca";
          mode = "n";
          action = ":CodeCompanionActions<CR>";
          desc = "Toggle Inline CodeCompanion Chat";
        }
        {
          key = "<leader>cc";
          mode = "n";
          action = ":CodeCompanionChat<CR>";
          desc = "Toggle CodeCompanion Chat Sidebar";
        }
      ];
    };
  };
}
