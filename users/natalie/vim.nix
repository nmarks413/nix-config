{...}: {
  imports = [
    ./vim/default.nix
  ];
  vim = {
    theme = {
      name = "catppuccin";
      style = "mocha";
    };
    hideSearchHighlight = true;
  };
}
