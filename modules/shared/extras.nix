{
  pkgs,
  config,
  inputs,
  ...
}: {
  networking = {
  };

  inputs.programs.nix-index-database.comma.enable = true;
}
