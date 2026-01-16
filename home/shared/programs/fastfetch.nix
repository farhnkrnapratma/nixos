{ config, ... }:
{
    programs.fastfetch = {
        enable = true;
        settings = {
            logo.source = "nixos_small";
            "$schema" = "https://github.com/fastfetch-cli/fastfetch/raw/master/doc/json_schema.json";
            modules = [
                "os"
                "kernel"
                "uptime"
                "packages"
                "shell"
                "cpu"
                "gpu"
            ];
        };
    };
}
