pkgs:
pkgs.python3Packages.buildPythonApplication {
  pname = "instagram-cli";
  version = "1.3.5";

  src = pkgs.fetchurl {
    url = "https://files.pythonhosted.org/packages/py3/i/instagram-cli/instagram_cli-1.3.5-py3-none-any.whl";
    sha256 = "sha256-Q66yF5alh6GaItYeLU0jQH+170ZWayFdq/euOgnZmY4=";
  };

  format = "wheel";

  doCheck = false;

  meta = {
    description = "The ultimate weapon against brainrot ";
    homepage = "https://pypi.org/project/instagram-cli/";
    license = pkgs.lib.licenses.mit;
  };
}
