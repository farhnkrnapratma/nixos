{ config
, lib
, pkgs
, ...
}:
{
  home = {
    stateVersion = "26.05";
    packages = with pkgs; [
      aria2
      bat
      brave
      eza
      gnome-calculator
      gnome-calendar
      gnome-characters
      gnome-clocks
      loupe
      nautilus
      papers
      snapshot
      wl-clipboard
      yaru-theme
      zoxide
    ];
  };

  programs = {
    fish = {
      enable = true;
      interactiveShellInit = ''
        set fish_greeting
        function fish_right_prompt
          date +"%H:%M:%S"
        end
        zoxide init fish | source
      '';
      preferAbbrs = true;
      shellAbbrs = {
        c = "clear";
        cat = "bat";
        cd = "z";
        l = "eza -lahgmuU --smart-group";
        ls = "eza";
        ncg = "sudo nix-collect-garbage -d";
        nrs = "sudo nixos-rebuild switch --flake";
        x = "exit";
      };
    };

    ghostty = {
      enable = true;
      enableFishIntegration = lib.mkIf config.programs.fish.enable true;
      clearDefaultKeybinds = false;
      installBatSyntax = true;
      settings = {
        adjust-cell-height = "15%";
        background-opacity = 0.9;
        cursor-style = "underline";
        cursor-style-blink = true;
        font-family = "JetBrains Mono";
        font-feature = "+calt, +liga, +dlig";
        font-size = 11;
        link-previews = true;
        shell-integration = if config.programs.fish.enable then "fish" else "detect";
        shell-integration-features = "no-cursor";
        theme = "dark:Detuned,light:TokyoNight Day";
        window-decoration = "none";
        window-padding-balance = true;
        window-padding-x = 3;
        window-padding-y = 3;
        window-show-tab-bar = "never";
        window-theme = "system";
      };
      systemd.enable = true;
    };
  };
}
