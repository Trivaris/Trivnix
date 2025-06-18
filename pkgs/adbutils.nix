{
  inputs,
  pkgs
}:

pkgs.python3Packages.buildPythonPackage {

  name = "adbutils";
  
  src = pkgs.lib.cleanSource inputs.adbutils-src;
  format = "pyproject";

  nativeBuildInputs = with pkgs.python3Packages; [
    setuptools
    pbr
  ];

  propagatedBuildInputs = with pkgs.python3Packages; [
    requests
    deprecation
    retry2
    pillow
  ];

  doCheck = false;

  env = {
    PBR_VERSION = "2.9.2";
  };

  meta = {
    description = "Pure Python ADB library for Google ADB service.";
    homepage = "https://github.com/openatx/adbutils";
    license = pkgs.lib.licenses.mit;
  };

}
