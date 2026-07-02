{
  networking.firewall = {
    enable = true;
    trustedInterfaces = [ "CloudflareWARP" ];
    filterForward = true;
    rejectPackets = false;
    logRefusedConnections = true;
    allowPing = true;
    pingLimit = "2/second burst 5 packets";
    checkReversePath = "loose";
    logReversePathDrops = true;
  };
}
