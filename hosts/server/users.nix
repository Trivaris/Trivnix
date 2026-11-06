{ inputs, self, ... }:
{
  flake.nixosModules.server = {
    home-manager.users.trivaris = {
      imports = [
        inputs.trivnixPrivate.homeModules.default
        self.homeModules.common-git
        self.homeModules.default
      ];

      config = {
        userPrefs.cli.enable = true;
        userInfos = {
          name = "trivaris";
          hashedPassword = "$y$j9T$ZYnirABSLjZi.mfiKE.Si0$Fe67Vw2MHKtZybsHVGf0rNqcnN67LgLdsCbM8q6ln/B";
          uid = 1000;
        };
      };
    };
  };
}
