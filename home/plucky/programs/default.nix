{ config
, lib
, pkgs
, ...
}:
let
  CodiumIsEnabled = config.programs.vscode.enable;
  WhenCodiumEnabled =
    { config
    , lib
    , pkgs
    , ...
    }:
    let
      CodiumOrNano = if CodiumIsEnabled then "codium" else "nano";
    in
    {
      home = {
        packages = lib.mkIf CodiumIsEnabled (
          with pkgs;
          [
            nixfmt
            shellcheck
            shfmt
          ]
        );
        sessionVariables = {
          EDITOR = CodiumOrNano;
          VISUAL = CodiumOrNano;
        };
      };
      programs = {
        gh.settings.editor = CodiumOrNano;
        git.settings.core.editor = CodiumOrNano;
      };
    };
in
{
  imports = [
    WhenCodiumEnabled
    ./gh.nix
    ./git.nix
    ./gpg.nix
    ./codium.nix
  ];
}
