{
  pkgs,
  ...
}:
let
  google-sans = pkgs.callPackage ./GoogleSans { inherit pkgs; };
  google-sans-code = pkgs.callPackage ./GoogleSansCode { inherit pkgs; };
in
{
  fonts.packages = with pkgs; [
    google-sans
    google-sans-code
    noto-fonts-cjk-sans
    nerd-fonts.jetbrains-mono
  ];
}
