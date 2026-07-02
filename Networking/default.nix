let
  env = fromTOML (builtins.readFile ../env.toml);
in
{
  imports = [
    ./NetworkManager
    ./firewall.nix
    ./nftables.nix
    ./time-servers.nix
  ];
  networking = {
    hostName = env.network.host;
    domain = env.network.domain;
    search = [ env.network.domain ];
    tempAddresses = "enabled";
  };
}
