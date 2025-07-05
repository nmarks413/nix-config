{ pkgs, host, ... }:
{
  vim = {
    lazy.plugins.cmp-vimtex = {
      enabled = true;
      package = pkgs.vimPlugins.cmp-vimtex;
      lazy = false;

    };
    lazy.plugins.vimtex = {
      enabled = true;
      package = pkgs.vimPlugins.vimtex;
      lazy = false;
    };

    globals = {
      tex_flavor = "latex";
      maplocalleader = "\\";
      vimtex_compiler_method = "latexmk";
      vimtex_view_method = if host.darwin then "skim" else "zathura";
      vimtex_view_automatic = 1;
      vimtex_compiler_latexmk = {
        callback = 1;
        continuous = 1;
        executable = "latexmk";
        hooks = [ ];
        options = [
          "-verbose"
          "-file-line-error"
          "-synctex=1"
          "-interaction=nonstopmode"
          "-shell-escape"
        ];
      };
      vimtex_log_ignore = [
        "Underfull"
        "Overfull"
        "specifier changed to"
        "Token not allowed in a PDF string"
      ];
      vimtex_quickfix_ignore_filters = [
        "Underfull"
        "Overfull"
      ];
    };

    autocomplete.blink-cmp = {
      sourcePlugins = {
        "blink.compat" = {
          enable = true;
          package = "blink-compat";
          module = "blink.compat.source";
        };
      };
      setupOpts = {
        sources = {
          default = [ "vimtex" ];
          providers = {
            vimtex = {
              name = "vimtex";
              module = "blink.compat.source";
              score_offset = 100;
            };
          };
        };
      };
    };

    augroups = [
      {
        name = "VimTeX Events";
      }
    ];
    autocmds = [
      {
        pattern = [ "VimtexEventViewReverse" ];
        event = [ "User" ];
        desc = "Return to nvim after reverse search";
        command = "call b:vimtex.viewer.xdo_focus_vim()";
        group = "VimTeX Events";
      }
      {
        pattern = [ "VimtexEventQuit" ];
        event = [ "User" ];
        desc = "Close pdf after exiting nvim";
        command = "VimtexClean";
        group = "VimTeX Events";
      }

      {
        pattern = [ "VimtexEventInitPost" ];
        event = [ "User" ];
        desc = "Start compiling when opening nvim to a tex file";
        command = "VimtexCompile";
        group = "VimTeX Events";
      }

    ];

    lsp = {
      servers = {
        texlab = {
          enable = true;
          cmd = [ "${pkgs.texlab}/bin/texlab" ];
          filetypes = [ "tex" ];
        };
      };
    };
    treesitter = {
      grammars = with pkgs.vimPlugins.nvim-treesitter.builtGrammars; [
        latex
      ];
    };
  };
}
