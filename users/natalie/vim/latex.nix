{pkgs, ...}: {
  vim = {
    lazy.plugins.vimtex = {
      enabled = true;
      package = pkgs.vimPlugins.vimtex;
      lazy = true;
      ft = "tex";
    };

    globals = {
      tex_flavor = "latex";
      maplocalleader = "\\";
      vimtex_compiler_method = "latexmk";
      vimtex_view_method = "zathura";
      vimtex_compiler_latexmk = {
        callback = 1;
        continuous = 1;
        executable = "latexmk";
        hooks = [];
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

    lsp = {
      servers = {
        texlab = {
          enable = true;
          cmd = ["${pkgs.texlab}/bin/texlab"];
          filetypes = ["tex"];
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
