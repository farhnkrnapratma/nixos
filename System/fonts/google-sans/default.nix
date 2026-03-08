{ pkgs }:

pkgs.stdenvNoCC.mkDerivation rec {
  pname = "google-sans";
  version = "6.001";
  src = ./${pname}.zip;
  nativeBuildInputs = [ pkgs.unzip ];
  dontBuild = true;
  installPhase = ''
    runHook preInstall
    find . -type f -exec install -Dm644 {} $out/share/fonts/truetype/${pname}-${version}/{} \;
    runHook postInstall
  '';
}
