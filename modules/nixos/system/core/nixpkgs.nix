{ self, ... }:
{
  flake.nixosModules.system-core = {
    nixpkgs.overlays = [ self.overlays.default ];
    nixpkgs.config = {
      allowUnfree = true;
      allowUnsupportedSystem = true;
      android_sdk.accept_license = true;

      permittedInsecurePackages = [
        "librewolf-bin-151.0.1-2"
        "librewolf-bin-unwrapped-151.0.1-2"
        "electron-39.8.10"
      ];

      problems.handlers = {
        "gtk+".broken = "warn";
      };
    };
  };
}
