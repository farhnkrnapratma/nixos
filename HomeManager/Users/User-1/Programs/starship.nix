{
  lib,
  config,
  ...
}:
{
  programs.starship = rec {
    enable = true;
    enableFishIntegration = config.programs.fish.enable;
    enableTransience = enableFishIntegration;
    configPath = "${config.xdg.configHome}/starship/starship.toml";
    presets = [ "nerd-font-symbols" ];
    settings = {
      add_newline = false;
      format = lib.concatStrings [
        "$directory"
        "$git_branch"
        "$git_status"
        "$aws"
        "$buf"
        "$bun"
        "$c"
        "$cpp"
        "$cmake"
        "$conda"
        "$crystal"
        "$dart"
        "$deno"
        "$docker_context"
        "$elixir"
        "$elm"
        "$fennel"
        "$fortran"
        "$fossil_branch"
        "$gcloud"
        "$golang"
        "$gradle"
        "$guix_shell"
        "$haskell"
        "$haxe"
        "$java"
        "$julia"
        "$kotlin"
        "$lua"
        "$meson"
        "$nim"
        "$nix_shell"
        "$nodejs"
        "$ocaml"
        "$package"
        "$perl"
        "$php"
        "$pixi"
        "$python"
        "$rlang"
        "$ruby"
        "$rust"
        "$scala"
        "$swift"
        "$xmake"
        "$zig"
        "$line_break"
        "[✦ ](bright-blue)"
        "[at ](bright-white)"
        "$time"
        "$character"
      ];
      directory = {
        style = "bright-cyan";
        truncation_length = 1;
        truncation_symbol = "../";
      };
      git_branch = {
        format = "on [$symbol$branch]($style) ";
        style = "bright-purple";
      };
      git_status = {
        format = "([$all_status$ahead_behind]($style) )";
        staged = "+";
        style = "bright-yellow";
      };
      time = {
        disabled = false;
        format = "[$time]($style) ";
        time_format = "%H:%M:%S";
        style = "bright-yellow";
      };
      character = {
        success_symbol = "[→](bright-green)";
        error_symbol = "[→](bright-red)";
      };
    };
  };
}
