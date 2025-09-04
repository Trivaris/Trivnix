{
  inputs,
  pkgs,
  outputs,
  ...
}:
{
  environment.systemPackages = [ pkgs.home-manager ];

  home-manager = {
    useUserPackages = true;
    backupFileExtension = "backup";

    extraSpecialArgs = {
      inherit inputs outputs;
    };
  };

}
