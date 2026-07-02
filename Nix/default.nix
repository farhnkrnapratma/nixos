{
  imports = [
    ./gc.nix
    ./optimise.nix
    ./settings.nix
  ];
  nix = {
    enable = true;
    checkAllErrors = true;
    checkConfig = true;
  };
}
