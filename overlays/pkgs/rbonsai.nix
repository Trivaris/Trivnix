{
  inputs,
  pkgs,
}:

pkgs.rustPlatform.buildRustPackage {

  pname = "rbonsai";
  version = inputs.rbonsai-src.shortRev;

  src = inputs.rbonsai-src;

  cargoHash = "sha256-78vOnu5RZgIR71x8fXbWmoeRDzRgaZBQXJ6nugLNij0=";

  nativeBuildInputs = with pkgs; [ ncurses5.dev ];
  buildInputs = with pkgs; [ ncurses5 ];

  meta = {
    description = "A terminal bonsai tree generator";
    homepage = "https://github.com/roberte777/rbonsai";
    license = pkgs.lib.licenses.gpl3Plus;
  };

}
