{ inputs, ... }:
{
  flake.lib = inputs.nixpkgs.lib.extend (
    final: prev: {
      trivnix = {
        mkReverseProxyOption = import ./mkReverseProxyOption.nix prev;
        reverseProxyOptions = import ./reverseProxyOptions.nix prev;
      };
    }
  );
}
