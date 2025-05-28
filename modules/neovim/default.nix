{ config, lib, ... }:
{
  # based on default options from upstream:
  # https://github.com/NotAShelf/nvf/blob/main/configuration.nix
  #
  # a full list of options is available too:
  # https://notashelf.github.io/nvf/options.html
  #
  # override level 999 is used to not conflict with mkDefault as used by nvf.
  # which allows user configurations to disable/override anything here.
  vim = lib.mkOverride 999 {
    theme = {
      enable = true;
    };
    visuals = {
      # notification system
      # https://github.com/j-hui/fidget.nvim
      fidget-nvim.enable = true;
      # highlight undo / paste / autoformat / macros
      # https://github.com/tzachar/highlight-undo.nvim
      highlight-undo.enable = true;
      # indentation guides
      # https://github.com/lukas-reineke/indent-blankline.nvim
      indent-blankline.enable = false;
      # extra icons
      nvim-web-devicons.enable = true;
      # https://github.com/petertriho/nvim-scrollbar
      nvim-scrollbar.enable = false;
    };
    lsp = {
      # Must be enabled for language modules to hook into the LSP API.
      enable = true;
      formatOnSave = true;
      # show errors inline
      # https://github.com/folke/trouble.nvim
      trouble.enable = true;
      # show lightbulb icon in gutter to indicate code actions
      # https://github.com/kosayoda/nvim-lightbulb
      lightbulb.enable = true;
      # show icons in auto-completion menu
      # https://github.com/onsails/lspkind.nvim
      lspkind.enable = config.vim.autocomplete.blink-cmp.enable;
    };
    treesitter = {
      enable = true;
      addDefaultGrammars = true;
    };
    debugger = {
      nvim-dap = {
        enable = true;
        ui.enable = true;
      };
    };
    languages = {
      enableFormat = true;
      enableTreesitter = true;
      enableExtraDiagnostics = true;

      # sort-lines: on
      bash.enable = true;
      clang.enable = true;
      css.enable = true;
      html.enable = true;
      markdown.enable = true;
      nix.enable = true;
      python.enable = true;
      rust.crates.enable = true;
      rust.enable = true;
      ts.enable = true;
      zig.enable = true;
      # sort-lines: off

      nix.format.type = "nixfmt"; # looks so much nicer
    };
    filetree = {
      neo-tree = {
        enable = false;
      };
    };
    tabline = {
      nvimBufferline.enable = true;
    };
    autocomplete = {
      blink-cmp = {
        enable = true;
        sourcePlugins = {
          ripgrep.enable = true;
        };
        friendly-snippets.enable = true;
      };
    };
    statusline = {
      lualine = {
        enable = true;
        refresh = {
          statusline = 100;
          tabline = 100;
          winbar = 100;
        };
      };
    };

    utility = {
      snacks-nvim = {
        enable = true;
        setupOpts = {
          bigfile.enable = true;
          explorer.replace_netrw = true;
          dashboard = {
            preset.keys = [
              {
                icon = " ";
                key = "n";
                desc = "New File";
                action = ":ene | startinsert";
              }
              {
                icon = " ";
                key = "r";
                desc = "Recent Files";
                action = ":lua Snacks.dashboard.pick('oldfiles')";
              }
            ];
            sections = [
              { section = "header"; }
              {
                section = "keys";
                indent = 2;
                padding = 1;
              }
              {
                icon = " ";
                title = "Projects";
                section = "projects";
                indent = 2;
                padding = 1;
              }
              {
                icon = " ";
                title = "Git";
                section = "terminal";
                enabled = lib.options.literalExpression ''
                  function()
                    return Snacks.git.get_root() ~= nil
                  end
                '';
                cmd = "git status --short --branch --renames";
                height = 10;
                padding = 1;
                ttl = 5 * 60;
                indent = 3;
              }
            ];
          };
          image.enable = true;
          notifier.timeout = 3000;
          picker = {
            enable = true;
            sources = {
              explorer = { };
            };
          };
        };
      };
    };

    binds = {
      whichKey.enable = true;
      cheatsheet.enable = true;
      # discourages bad keyboard habit, e.g. disables arrow keys, explains better binds
      # https://github.com/m4xshen/hardtime.nvim
      hardtime-nvim.enable = true;
      hardtime-nvim.setupOpts = {
        disable_mouse = false;
        restriction_mode = "hint"; # default behavior is lenient
      };
    };
    ui = {
      borders.enable = true;
      # https://github.com/norcalli/nvim-colorizer.lua
      colorizer.enable = true;
      # https://github.com/RRethy/vim-illuminate
      illuminate.enable = true;
      breadcrumbs = {
        enable = false;
        navbuddy.enable = config.vim.ui.breadcrumbs.enable;
      };
      smartcolumn = {
        enable = true;
        setupOpts.custom_colorcolumn = {
          # this is a freeform module, it's `buftype = int;` for configuring column position
          nix = "110";
          ruby = "120";
          java = "130";
          go = [
            "90"
            "130"
          ];
        };
      };
    };
    notes = {
      todo-comments.enable = true;
    };
    git = {
      enable = true;
      gitsigns.enable = true;
      gitsigns.codeActions.enable = false; # throws an annoying debug message
    };
  };
}
