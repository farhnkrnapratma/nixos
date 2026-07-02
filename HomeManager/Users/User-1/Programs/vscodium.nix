{
  pkgs,
  config,
  ...
}:
let
  env = fromTOML (builtins.readFile ../../../../env.toml);
in
{
  programs.vscodium = {
    enable = true;
    package = pkgs.vscodium;
    mutableExtensionsDir = false;
    profiles.default = {
      enableExtensionUpdateCheck = false;
      enableUpdateCheck = false;
      extensions = with pkgs.vscode-extensions; [
        bierner.github-markdown-preview
        bradlc.vscode-tailwindcss
        editorconfig.editorconfig
        github.github-vscode-theme
        github.vscode-github-actions
        github.vscode-pull-request-github
        jnoortheen.nix-ide
        ms-python.python
        ms-vscode.cpptools-extension-pack
        nefrob.vscode-just-syntax
        pkief.material-icon-theme
        rust-lang.rust-analyzer
        tamasfe.even-better-toml
      ];
      userSettings = {
        chat.disableAIFeatures = true;
        editor = {
          autoIndent = "full";
          autoIndentOnPaste = true;
          cursorBlinking = "smooth";
          cursorSmoothCaretAnimation = "on";
          cursorStyle = "underline";
          fontFamily = "'${env.fonts.mono}', monospace";
          fontLigatures = true;
          fontSize = 14;
          inertialScroll = true;
          minimap.enabled = true;
          overtypeCursorStyle = "underline";
          smoothScrolling = true;
          tabCompletion = "on";
          tabSize = 2;
          trimWhitespaceOnDelete = true;
          unfoldOnClickAfterEndOfLine = true;
          wordWrap = "off";
          wordWrapColumn = 100;
        };
        explorer = {
          confirmDelete = false;
          confirmDragAndDrop = false;
        };
        extensions = {
          autoCheckUpdates = false;
          autoUpdate = false;
          closeExtensionDetailsOnViewChange = true;
          ignoreRecommendations = true;
          verifySignature = false;
        };
        files = {
          autoSave = "onFocusChange";
          autoSaveWhenNoErrors = true;
          autoSaveWorkspaceFilesOnly = true;
          eol = "\n";
          insertFinalNewline = true;
          simpleDialog.enable = true;
          trimFinalNewlines = true;
        };
        scm = {
          alwaysShowActions = true;
          alwaysShowRepositories = true;
          defaultViewMode = "tree";
          providerCountBadge = "auto";
          repositories.explorer = true;
        };
        search = {
          defaultViewMode = "tree";
          showLineNumbers = true;
          smartCase = true;
        };
        terminal.integrated = {
          allowInUntrustedWorkspace = true;
          cursorBlinking = true;
          cursorStyle = "underline";
          cursorStyleInactive = "line";
          defaultProfile.linux = "fish";
          enableImages = true;
          fontFamily = "'${env.fonts.nerd}', monospace";
          fontLigatures = {
            enabled = true;
            featureSettings = "\"calt\" on, \"liga\" on, \"dlig\" on";
          };
          fontSize = 14;
          gpuAcceleration = "on";
          smoothScrolling = true;
        };
        update = {
          mode = "none";
          showReleaseNotes = false;
        };
        window.autoDetectColorScheme = true;
        workbench = {
          editor.showTabIndex = true;
          externalBrowser = "${config.home.profileDirectory}/bin/firefox";
          iconTheme = "material-icon-theme";
          preferredDarkColorTheme = "GitHub Dark";
          preferredLightColorTheme = "GitHub Light";
          startupEditor = "none";
          tips.enabled = false;
          tree.renderIndentGuides = "always";
        };
        json.schemaDownload.trustedDomains = {
          "https://schemastore.azurewebsites.net/" = true;
          "https://raw.githubusercontent.com/microsoft/vscode/" = true;
          "https://raw.githubusercontent.com/devcontainers/spec/" = true;
          "https://www.schemastore.org/" = true;
          "https://json.schemastore.org/" = true;
          "https://json-schema.org/" = true;
          "https://developer.microsoft.com/json-schemas/" = true;
          "https://biomejs.dev" = true;
        };
      };
    };
  };
}
