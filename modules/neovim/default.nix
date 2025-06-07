{
  config,
  pkgs,
  lib,
  ...
}:
let
  allowExe = config.shared.allowExe;
in
{
  # based on default options from upstream:
  # https://github.com/NotAShelf/nvf/blob/main/configuration.nix
  #
  # a full list of options is available too:
  # https://notashelf.github.io/nvf/options.html
  #
  # override level 999 is used to not conflict with mkDefault as used by nvf.
  # which allows user configurations to disable/override anything here.
  config.vim = lib.mkOverride 999 {
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
      enable = allowExe;
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
    debugger = {
      nvim-dap = {
        enable = allowExe;
        ui.enable = true;
      };
    };
    languages = {
      enableFormat = true;
      enableTreesitter = allowExe;
      enableExtraDiagnostics = true;

      # sort-lines: on
      assembly.enable = allowExe;
      bash.enable = allowExe;
      clang.enable = allowExe;
      css.enable = allowExe;
      html.enable = allowExe;
      nix.enable = allowExe;
      rust.crates.enable = allowExe;
      rust.enable = allowExe;
      ts.enable = allowExe;
      zig.enable = allowExe;
      # sort-lines: off

      ts.format.enable = false; # deno fmt is enabled elsewhere
      nix.format.type = "nixfmt"; # looks so much nicer
    };
    formatter.conform-nvim = {
      enable = true;
      setupOpts.formatters_by_ft = {
        typescript = [ "deno_fmt" ];
        typescriptreact = [ "deno_fmt" ];
        javascript = [ "deno_fmt" ];
        javascriptreact = [ "deno_fmt" ];
      };
      setupOpts.formatters.deno_fmt = {
        command = lib.meta.getExe pkgs.deno;
      };
    };
    filetree = {
      neo-tree = {
        enable = true;
      };
    };
    tabline = {
      nvimBufferline.enable = true;
    };
    autocomplete = {
      blink-cmp.enable = allowExe;
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
      enable = allowExe;
      gitsigns.enable = allowExe;
      gitsigns.codeActions.enable = false; # throws an annoying debug message
    };
  };
}
