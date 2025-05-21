{pkgs, ...}: {
  imports = [
    ./vim/default.nix
  ];
  vim = {
    options = {
      tabstop = 2;
      softtabstop = 2;
      shiftwidth = 2;
      undofile = true;
      swapfile = false;
      showmode = false;
      foldlevel = 99;
      foldcolumn = "1";
      foldlevelstart = 99;
      foldenable = true;
    };

    autocmds = [
    ];
    theme = {
      name = "catppuccin";
      style = "mocha";
    };
    hideSearchHighlight = true;
  };
}
