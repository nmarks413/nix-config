{pkgs, ...}: {
  vim = {
    lazy.plugins."lean.nvim" = {
      enabled = true;
      package = pkgs.vimPlugins.lean-nvim;
      lazy = true;
      ft = "lean";
    };
  };
}
