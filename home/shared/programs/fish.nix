{ config
, ...
}:
{
  programs.fish = {
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
}
