{
  pkgs,
  ...
}:
{
  programs.bat = {
    enable = true;
    extraPackages = with pkgs.bat-extras; [
      batdiff
      batgrep
      batman
      batpipe
      batwatch
    ];
    config = {
      binary = "as-text";
      color = "always";
      decorations = "always";
      italic-text = "never";
      nonprintable-notation = "caret";
      number = true;
      tabs = "2";
      theme-dark = "Catppuccin Mocha";
      theme-light = "Catppuccin Latte";
      wrap = "auto";
    };
  };
}
