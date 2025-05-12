{
  config,
  pkgs,
  ...
}:
{
  services.sketchybar = {
    enable = config.shared.darwin.tiling.enable;
    package = pkgs.sketchybar;
  };
}
