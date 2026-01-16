{
    config,
    lib,
    pkgs,
    ...
}:
let
    CodeIsEnabled = config.programs.vscode.enable;
    WhenVSCodeEnabled =
        {
            config,
            lib,
            pkgs,
            ...
        }:
        let
            CodeOrNano = if CodeIsEnabled then "codium" else "nano";
        in
        {
            home = {
                packages = lib.mkIf CodeIsEnabled (
                    with pkgs;
                    [
                        nixfmt
                        shellcheck
                        shfmt
                    ]
                );
                sessionVariables = {
                    EDITOR = CodeOrNano;
                    VISUAL = CodeOrNano;
                };
            };
            programs = {
                gh.settings.editor = CodeOrNano;
                git.settings.core.editor = CodeOrNano;
            };
        };
in
{
    imports = [
        WhenVSCodeEnabled
        ./gh.nix
        ./git.nix
        ./gpg.nix
        ./vscode.nix
    ];
}
