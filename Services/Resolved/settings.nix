{
  services.resolved.settings.Resolve = {
    DNS = [
      "1.1.1.1#cloudflare-dns.com"
      "[2606:4700:4700::1111]#cloudflare-dns.com"
    ];
    FallbackDNS = [
      "9.9.9.9#dns.quad9.net"
      "[2620:fe::fe]#dns.quad9.net"
    ];
    DNSOverTLS = "yes";
    DNSSEC = "yes";
    DNSStubListener = "yes";
    MulticastDNS = "no";
    Cache = "yes";
    LLMNR = "no";
    StaleRetentionSec = "300";
  };
}
