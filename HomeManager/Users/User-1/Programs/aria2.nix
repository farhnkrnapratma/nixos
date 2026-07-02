{
  programs.aria2 = {
    enable = true;
    settings = {
      max-concurrent-downloads = 10;
      split = 10;
      max-connection-per-server = 5;
      min-split-size = "5M";
      optimize-concurrent-downloads = "true";
      file-allocation = "falloc";
      disk-cache = "64M";
      continue = true;
      retry-wait = 5;
      connect-timeout = 20;
      check-certificate = true;
      http-accept-gzip = true;
      enable-dht = true;
      enable-dht6 = true;
      enable-peer-exchange = true;
      bt-enable-lpd = true;
      seed-ratio = 0.0;
      seed-time = 0;
    };
  };
}
