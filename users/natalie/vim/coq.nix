{ pkgs, ... }:
{

  vim = {
    # extraPackages = with pkgs; [
    #   coq_8_20
    #   coqPackages_8_20.stdlib
    # ];
    extraPlugins.Coqtail = {
      # enabled = true;
      package = pkgs.vimPlugins.Coqtail;
      # lazy = true;
      # ft = "coq";
    };
  };
}
