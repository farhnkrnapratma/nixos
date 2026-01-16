{ config, ... }:
{
    programs.starship = {
        enable = true;
        configPath = "${config.xdg.configHome}/starship/starship.toml";
        settings = {
            "$schema" = "https://starship.rs/config-schema.json";
            add_newline = false;
        };
    };
}
