{ inputs, ... }:
{
  flake.lib = inputs.nixpkgs.lib.extend (
    final: prev: {
      trivnix = {
        mkReverseProxyOption = import ./_mkReverseProxyOption.nix prev;
        reverseProxyOptions = import ./_reverseProxyOptions.nix prev;
      };
    }
  );
}
