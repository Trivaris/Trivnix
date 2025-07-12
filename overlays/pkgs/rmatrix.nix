{
  inputs,
  pkgs,
}:

pkgs.rustPlatform.buildRustPackage {

  name = "r-matrix";

  src = inputs.rmatrix-src;

  cargoHash = "sha256-PGQNxvoltpWRi4svK2NK+HFbu2vR7BJstDilAe1k748=";

  nativeBuildInputs = with pkgs; [ ncurses5.dev ];
  buildInputs = with pkgs; [ ncurses5 ];

  meta = {
    description = "Rust port of cmatrix";
    homepage = "https://github.com/Fierthraix/rmatrix";
    license = pkgs.lib.licenses.gpl3Plus;
  };

}
