{ pkgs, ... }:
let
  inherit (pkgs.lib) licenses;
in
pkgs.python3Packages.buildPythonApplication {
  pname = "instagram-cli";
  version = "1.3.5";

  format = "wheel";
  doCheck = false;

  src = pkgs.fetchurl {
    url = "https://files.pythonhosted.org/packages/py3/i/instagram-cli/instagram_cli-1.3.5-py3-none-any.whl";
    sha256 = "sha256-Q66yF5alh6GaItYeLU0jQH+170ZWayFdq/euOgnZmY4=";
  };

  meta = {
    description = "The ultimate weapon against brainrot ";
    homepage = "https://pypi.org/project/instagram-cli/";
    license = licenses.mit;
  };
}
