{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    ffmpeg
    ripgrep
    reaper
  ];
  shared.darwin = {
    macAppStoreApps = [
      "final-cut-pro"
      "logic-pro"
      "motion"
    ];
  };
}
