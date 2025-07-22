{ ... }:
{
  config.vim.options = {
    # Indentation
    tabstop = 2;
    softtabstop = 2;
    shiftwidth = 2;
    showmode = false;

    # Default to treesitter folding
    foldenable = true;
    foldmethod = "expr";
    foldexpr = "v:lua.vim.treesitter.foldexpr()";
    foldlevel = 99;
    foldcolumn = "1";
    foldlevelstart = 99;

    # Case-insensitive find-in-file
    ignorecase = true;
    smartcase = true;

    # Enable swapfile, but not in the same location as the source files.
    undofile = true;
    swapfile = true;
  };
}
