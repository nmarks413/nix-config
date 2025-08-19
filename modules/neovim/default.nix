{
  config,
  pkgs,
  lib,
  ...
}:
{
  imports = [
    ./formatter.nix
    ./keybind.nix
    ./options.nix
  ];
  # based on default options from upstream:
  # https://github.com/NotAShelf/nvf/blob/main/configuration.nix
  #
  # a full list of options is available too:
  # https://notashelf.github.io/nvf/options.html
  #
  # override level 999 is used to not conflict with mkDefault as used by nvf.
  # which allows user configurations to disable/override anything here.
  config.vim = lib.mkOverride 999 {
    extraLuaFiles = [
      ./lib.lua
    ];

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
      indent-blankline.enable = true;
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
      lightbulb.enable = false;
      # show icons in auto-completion menu
      # https://github.com/onsails/lspkind.nvim
      lspkind.enable = config.vim.autocomplete.blink-cmp.enable;
      # Enables inlay hints (types info in rust and shit)
      inlayHints.enable = true;
      #Nice mappings that i use :3
      mappings = {
        codeAction = "<leader>ca";
        goToDeclaration = "gD";
        goToDefinition = "gd";
        listReferences = "gr";
        goToType = "gy";
        hover = "K";
        nextDiagnostic = null; # ]d
        openDiagnosticFloat = "<leader>d";
        renameSymbol = "rn";
        documentHighlight = null;
        listDocumentSymbols = null;
        listImplementations = null;
        listWorkspaceFolders = null;
        previousDiagnostic = null;
        removeWorkspaceFolder = null;
        signatureHelp = null;
        toggleFormatOnSave = null;
      };
      servers.nixd.init_options.autoArchive = true;
    };
    treesitter = {
      enable = true;
      addDefaultGrammars = true;
    };
    debugger.nvim-dap = {
      enable = true;
      ui.enable = true;
    };
    languages = {
      enableFormat = true;
      enableTreesitter = true;
      enableExtraDiagnostics = true;
      # enable debug adapter protocol by default
      enableDAP = true;

      # sort-lines: on
      bash.enable = true;
      clang.enable = true;
      css.enable = true;
      html.enable = true;
      lua.enable = true;
      markdown.enable = true;
      nix.enable = true;
      python.enable = true;
      rust.crates.enable = true;
      rust.enable = true;
      ts.enable = true;
      zig.enable = true;
      # sort-lines: off
    };
    filetree.neo-tree = {
      enable = true;
      setupOpts = {
        enable_cursor_hijack = true;
        git_status_async = true;
      };
    };
    fzf-lua = {
      enable = true;
      setupOpts = {
        fzf_colors = true;
        keymap.fzf = {
          "ctrl-q" = "select-all+accept";
        };
      };
    };
    autocomplete.blink-cmp = {
      enable = true;
      mappings = {
        close = null;
        complete = null;
        confirm = null;
        next = null;
        previous = null;
        scrollDocsDown = null;
        scrollDocsUp = null;
      };
      setupOpts = {
        keymap = {
          preset = "super-tab";
        };
        completion = {
          ghost_text.enabled = false;
          list.selection.preselect = true;
          trigger = {
            show_in_snippet = true;
          };
          accept.auto_brackets.enabled = true;
        };
        signature.enabled = true;
      };
      sourcePlugins = {
        ripgrep.enable = true;
      };
      friendly-snippets.enable = true;
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
    binds = {
      whichKey.enable = true;
      cheatsheet.enable = true;
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
    };
    notes = {
      todo-comments.enable = true;
    };
    git = {
      enable = true;
      gitsigns.enable = true;
      gitsigns.codeActions.enable = false; # throws an annoying debug message
    };
    # Better help docs
    lazy.plugins."helpview.nvim" = {
      enabled = true;
      package = pkgs.vimPlugins.helpview-nvim;
      lazy = false;
    };
  };
}
