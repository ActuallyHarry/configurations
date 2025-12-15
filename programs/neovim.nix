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
      statusline.lualine.enable = true;
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
        enable = true;
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
      autocomplete.blink-cmp = {
        enable = true;
        setupOpts = {
          signature.enabled = true;
        };
      };

      # Keymaps
      keymaps = [
        # File Explorer
        {
          key = "<leader>e";
          mode = "n";
          action = ":Neotree toggle<CR>";
          desc = "Toggle Explorer";
        }
        # Telescope
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
        # Terminal
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
        # Lazy Git
        {
          key = "<leader>g";
          mode = "n";
          action = ":ToggleTerm cmd=lazygit<CR>";
          desc = "Launch Lazygit";
        }
      ];
    };
  };
}
