{ config, pkgs, ... }:
{
  programs.vscode = {
    enable = true;
    package = pkgs.vscodium;
    mutableExtensionsDir = false;
    profiles.default = {
      extensions = with pkgs.vscode-extensions; [
        astro-build.astro-vscode
        bierner.github-markdown-preview
        bmalehorn.vscode-fish
        editorconfig.editorconfig
        github.vscode-github-actions
        github.vscode-pull-request-github
        github.github-vscode-theme
        jgclark.vscode-todo-highlight
        jnoortheen.nix-ide
        mads-hartmann.bash-ide-vscode
        ms-python.debugpy
        ms-python.flake8
        ms-python.mypy-type-checker
        ms-python.pylint
        ms-python.python
        ms-python.vscode-pylance
        pkief.material-icon-theme
        redhat.java
        rust-lang.rust-analyzer
        tamasfe.even-better-toml
        unifiedjs.vscode-mdx
      ];
      userSettings = {
        "chat.disableAIFeatures" = true;
        "debug.console.fontFamily" = "'JetBrains Mono', monospace";
        "editor.autoIndent" = "full";
        "editor.formatOnSave" = true;
        "editor.defaultFormatter" = "jnoortheen.nix-ide";
        "editor.fontFamily" = "'JetBrains Mono', monospace";
        "editor.fontLigatures" = true;
        "editor.fontSize" = 14;
        "editor.wordWrap" = "off";
        "editor.cursorSmoothCaretAnimation" = "on";
        "editor.cursorStyle" = "underline";
        "editor.overtypeCursorStyle" = "underline";
        "editor.tabSize" = 4;
        "editor.minimap.enabled" = false;
        "editor.tabCompletion" = "on";
        "explorer.confirmDelete" = false;
        "explorer.confirmDragAndDrop" = false;
        "files.autoSave" = "onFocusChange";
        "redhat.telemetry.enabled" = false;
        "scm.inputFontFamily" = "'JetBrains Mono', monospace";
        "terminal.integrated.fontFamily" = "'JetBrains Mono', monospace";
        "terminal.integrated.fontLigatures.enabled" = true;
        "terminal.integrated.fontLigatures.featureSettings" = "\"calt\" on, \"liga\" on";
        "terminal.integrated.cursorStyle" = "underline";
        "terminal.integrated.cursorStyleInactive" = "line";
        "terminal.integrated.cursorBlinking" = true;
        "workbench.startupEditor" = "none";
        "workbench.iconTheme" = "material-icon-theme";
        "workbench.colorTheme" = "GitHub Dark";
      };
    };
  };
}
