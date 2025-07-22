{ pkgs, ... }:
pkgs.rustPlatform.buildRustPackage {
  pname = "r-matrix";
  version = "0.2.7";

  src = pkgs.fetchFromGitHub {
    owner = "Fierthraix";
    repo = "rmatrix";
    rev = "1afcdd388d8f0955acf816bcec4731eab928a809";
    sha256 = "sha256-TwWg31l796K2aX0CZ+3D0FPuUqQ8hu1QpXMsMZgZqjo=";
  };

  cargoHash = "sha256-PGQNxvoltpWRi4svK2NK+HFbu2vR7BJstDilAe1k748=";

  nativeBuildInputs = with pkgs; [ ncurses5.dev ];
  buildInputs = with pkgs; [ ncurses5 ];

  meta = with pkgs.lib; {
    description = "Rust port of cmatrix";
    homepage = "https://github.com/Fierthraix/rmatrix";
    license = licenses.mit;
  };
}
