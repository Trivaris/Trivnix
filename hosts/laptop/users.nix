{ inputs, self, ... }:
{
  flake.nixosModules.laptop = {
    home-manager.users.trivaris = {
      imports = [
        inputs.trivnixPrivate.homeModules.default
        self.homeModules.common-git
        self.homeModules.common-home
        self.homeModules.default
      ];

      config = {
        services.syncthing = {
          enable = true;
          overrideDevices = false;
          overrideFolders = false;
        };

        userInfos = {
          name = "trivaris";
          hashedPassword = "$y$j9T$ZYnirABSLjZi.mfiKE.Si0$Fe67Vw2MHKtZybsHVGf0rNqcnN67LgLdsCbM8q6ln/B";
          uid = 1000;
        };

        userPrefs = {
          thunderbird.enable = true;
          prismlauncher.enable = true;
          email.enable = true;
          cli.enable = true;
          remmina.enable = true;
          vscode.enable = true;
        };
      };
    };
  };
}
