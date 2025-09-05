{
  inputs,
  pkgs,
  ...
}:
{
  environment.systemPackages = [ pkgs.home-manager ];
  home-manager = {
    useUserPackages = true;
    backupFileExtension = "backup";
    extraSpecialArgs = { inherit inputs; };
  };
}
