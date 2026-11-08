{ inputs, self, ... }:
{
  flake.nixosModules.system-core = {
    nixpkgs = {
      overlays = [
        inputs.hyprqt6engine.overlays.default
        self.overlays.default
      ];
      config = {
        allowUnfree = true;
        allowUnsupportedSystem = true;
        android_sdk.accept_license = true;

        permittedInsecurePackages = [
          # "librewolf-bin-151.0.1-2"
          # "librewolf-bin-unwrapped-151.0.1-2"
          # "electron-39.8.10"
        ];
      };
    };
  };
}
