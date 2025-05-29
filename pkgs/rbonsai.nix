{
  pkgs,
  ...
}:
  
pkgs.rustPlatform.buildRustPackage {
  
  pname = "rbonsai";
  version = "0.1.5";

  src = pkgs.fetchFromGitHub {
    owner = "Ethan Wilkes";
    repo = "rbonsai";
    rev = "368d0a28c347510a6db909f8019c47d459746e84";
    sha256 = "sha256-TwWg31l796K2aX0CZ+3D0FPuUqQ8hu1QpXMsMZgZqjo=";
  };

  cargoHash = "sha256-PGQNxvoltpWRi4svK2NK+HFbu2vR7BJstDilAe1k748=";

  meta = {
    description = "A terminal bonsai tree generator";
    homepage = "https://github.com/roberte777/rbonsai";
    license = pkgs.lib.licenses.gpl3Plus;
  };

}