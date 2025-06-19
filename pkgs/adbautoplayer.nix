{ inputs, pkgs }:

pkgs.python3Packages.buildPythonApplication {
  pname = "adbautoplayer-cli";
  version = "unstable";

  src = pkgs.lib.cleanSource "${inputs.adbautoplayer-src}/python";

  pyproject = true;

  nativeBuildInputs = with pkgs; [
    uv
    python3
    python3Packages.hatchling
  ];

  propagatedBuildInputs = with pkgs; [
    (pkgs.callPackage ./adbutils.nix { inherit inputs pkgs; })
    python3Packages.pure-python-adb
    python3Packages.av
    python3Packages.opencv-python
    python3Packages.pillow
    python3Packages.pydantic
  ];

  env = {
    UV_CACHE_DIR = "${placeholder "TMPDIR"}/uv-cache";
  };

  doCheck = false;

  meta = {
    description = "Automated Android UI testing tool (CLI)";
    homepage = "https://github.com/AdbAutoPlayer/AdbAutoPlayer";
    license = pkgs.lib.licenses.mit;
  };
}
