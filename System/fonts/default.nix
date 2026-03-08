{
  pkgs,
  ...
}:
let
  google-sans = pkgs.callPackage ./google-sans { inherit pkgs; };
  google-sans-code = pkgs.callPackage ./google-sans-code { inherit pkgs; };
in
{
  fonts = {
    fontconfig.defaultFonts = {
      monospace = [ "Noto Sans Mono" ];
      sansSerif = [ "Noto Sans" ];
      serif = [ "Noto Serif" ];
    };
    packages = with pkgs; [
      google-sans
      google-sans-code
      noto-fonts-cjk-sans
    ];
  };
}
