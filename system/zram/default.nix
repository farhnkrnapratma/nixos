{ config
, ...
}:

{
  zramSwap = {
    enable = true;
    algorithm = "lz4";
    memoryMax = 3221225472;
    memoryPercent = 40;
  };
}
