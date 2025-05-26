{
  pkgs,
  ...
}:
  
pkgs.rustPlatform.buildRustPackage {
  
  pname = "rbonsai";
  version = "0.1.5";

  src = pkgs.fetchFromGitHub {
    owner = "roberte777";
    repo = "rbonsai";
    rev = "v0.1.5";
    sha256 = "sha256-69MArXaMZLchKURM0koLACKWhm3NO+ZVoZsiHt9PkjQ=";
  };

  cargoHash = "sha256-78vOnu5RZgIR71x8fXbWmoeRDzRgaZBQXJ6nugLNij0=";

  meta = {
    description = "A terminal bonsai tree generator";
    homepage = "https://github.com/roberte777/rbonsai";
    license = pkgs.lib.licenses.gpl3Plus;
  };

}