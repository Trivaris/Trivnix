{
  stdenv,
  fetchFromGitHub,
  ...
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "quartz";
  version = "v5";
  src = fetchFromGitHub {
    owner = "jackyzha0";
    repo = "quartz";
    rev = "ab346fa66a895e12d63a308e70ce330ba795822a";
    hash = "sha256-Tv2xwlMDz2mH0OnSHuMybYa/QgGrH81PKJ6B2T0YfS8=";
  };

  nativeBuildInputs = [ ];

  installPhase = ''
    mkdir $out
    cp ./* $out/ -r
  '';
})
