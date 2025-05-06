# Configuration applied to all of chloe's machines
{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    ffmpeg
    ripgrep
  ];
  shared.darwin = {
    macAppStoreApps = [
      "final-cut-pro"
      "logic-pro"
      "motion"
    ];
  };
}
