{
  python3Packages,
  fetchFromGitHub,
  python3,
  lib,
  ...
}:
let
  py = python3Packages;

  cloudflare = py.buildPythonPackage {
    pname = "cloudflare";
    version = "2.19.4";
    pyproject = true;
    build-system = [
      py.setuptools
      py.wheel
    ];

    propagatedBuildInputs = [
      py.requests
      py.pyyaml
      py.jsonlines
    ];

    src = py.fetchPypi {
      pname = "cloudflare";
      version = "2.19.4";
      sha256 = "sha256-O2AAoBojfCO8z99tICVupREex0qCaunnT58OW7WyOD8=";
    };
  };
in
py.buildPythonApplication {
  pname = "cloudflare-dyndns";
  version = "unstable-2025-10-18";
  format = "other";

  src = fetchFromGitHub {
    owner = "L480";
    repo = "cloudflare-dyndns";
    rev = "6eb8cf53c2fb0632d126733194facab396888d4a";
    sha256 = "sha256-bECVhjn2mk0qHKtfcdSTUu31mcwzDYGbZjuLYi0S900=";
  };

  propagatedBuildInputs = [
    cloudflare
    py.requests
    py.flask
    py.waitress
  ];

  installPhase = ''
    mkdir -p $out/bin
    echo "#!${python3.interpreter}" > $out/bin/cloudflare-dyndns
    cat app.py >> $out/bin/cloudflare-dyndns
    chmod +x $out/bin/cloudflare-dyndns
  '';

  meta = {
    description = "Cloudflare DynDNS client for FRITZ!Box";
    homepage = "https://github.com/L480/cloudflare-dyndns";
    license = lib.licenses.mit;
    mainProgram = "cloudflare-dyndns";
  };
}
