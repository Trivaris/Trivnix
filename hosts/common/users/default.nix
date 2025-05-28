{
  pkgs,
  hostInfo,
  ...
}: {

  imports = map (user: ././${user}.nix) hostInfo.users;

}