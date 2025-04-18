{
  pkgs,
  config,
  inputs,
  hostName,
  mkIfElse,
  darwin,
  ...
}: {
  networking = {
    inherit hostName;
    networkmanager = !darwin;
  };
}
