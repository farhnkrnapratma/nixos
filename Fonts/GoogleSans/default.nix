{ pkgs }:
pkgs.stdenvNoCC.mkDerivation rec {
  pname = "google-sans";
  version = "1";
  src = ./${pname}.zip;
  nativeBuildInputs = [ pkgs.unzip ];
  dontBuild = true;
  installPhase = ''
    runHook preInstall
    find . -type f -name "*.ttf" -exec install -Dm644 {} $out/share/fonts/truetype/${pname}/{} \;
    runHook postInstall
  '';
}
