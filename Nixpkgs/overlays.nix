{
  inputs,
  ...
}:
{
  nixpkgs.overlays = [ inputs.cachyos-kernel.overlays.default ];
}
