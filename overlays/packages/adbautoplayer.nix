{ pkgs, ... }:
let
  inherit (pkgs.lib) platforms licenses;
  adbutils =
    let
      adbutils = {
        pname = "adbutils";
        version = "2.8.7";

        format = "pyproject";
        doCheck = false;
        nativeBuildInputs = [ pkgs.python3Packages.pbr ];
        pythonImportsCheck = [ "adbutils" ];

        src = pkgs.fetchPypi {
          inherit (adbutils) pname version;
          sha256 = "sha256-jjSJ1Kg2lQCVHwjP5tv94d29+GuaqpZkH4IhgRlfoM8=";
        };

        propagatedBuildInputs = builtins.attrValues {
          inherit (pkgs.python3Packages)
            requests
            deprecation
            retry
            pillow
            ;
        };
      };
    in
    pkgs.python3Packages.buildPythonPackage adbutils;
in
pkgs.python3Packages.buildPythonApplication {
  pname = "adbautoplayer";
  version = "9.0.3";

  nativeBuildInputs = [ pkgs.python3Packages.hatchling ];
  sourceRoot = "AdbAutoPlayer-1795072/python";
  format = "pyproject";
  doCheck = false;

  src = pkgs.fetchgit {
    url = "https://github.com/AdbAutoPlayer/AdbAutoPlayer.git";
    rev = "179507260b2ec3c87d177fd4ed6f5c0388dd8981";
    sha256 = "sha256-7+Dnm2yNdeVtKIQI3uHG4htDHMSO5pB1iUY51MAikdk=";
  };

  propagatedBuildInputs = builtins.attrValues {
    inherit adbutils;
    inherit (pkgs.python3Packages)
      opencv-python
      pydantic
      av
      pillow
      pytesseract
      ;
  };

  meta = {
    description = "Automated Android game player using ADB";
    homepage = "https://adbautoplayer.github.io";
    license = licenses.mit;
    platforms = platforms.linux;
  };
}
