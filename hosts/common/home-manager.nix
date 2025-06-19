{
  inputs,
  pkgs,
  outputs,
  ...
}:
{
  imports = [ inputs.home-manager.nixosModules.home-manager ];

  environment.systemPackages = with pkgs; [ home-manager ];

  home-manager = {
    useUserPackages = true;
    extraSpecialArgs = {
      inherit inputs outputs;
    };
    backupFileExtension = "backup";
  };

}
