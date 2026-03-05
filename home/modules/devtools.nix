{
  osConfig,
  lib,
  ...
}:
{
  config = lib.mkIf osConfig.hostPrefs.enableDevStuffs {
    programs.distrobox = {
      enable = true;
      containers.ubuntu-testing = {
        image = "ubuntu:24.04";
        additional_packages = [
          "git"
          "cmake"
          "ninja-build"
          "build-essential"
          "gcc-multilib"
          "g++-multilib"
          "pkg-config"
        ];
        init_hooks =
        let
          binaryLibs = [
            "libfmt-dev:i386"
            "libgit2-dev:i386"
            "libpcre2-dev:i386"
            "libminizip-dev:i386"
            "libabsl-dev:i386"
            "libre2-dev:i386"
            "zlib1g-dev:i386"
            "libcurl4-gnutls-dev:i386"
          ];
          headerOnlyLibs = [
            "nlohmann-json3-dev"
            "libasio-dev"
            "libwebsocketpp-dev"
          ];
        in [
          "sudo dpkg --add-architecture i386"
          "sudo apt-get update"
          "sudo apt-get install -y software-properties-common curl"

          # Install python 3.11
          "sudo add-apt-repository ppa:deadsnakes/ppa -y"
          "sudo apt-get update"
          "sudo apt-get install -y python3.11:i386 python3.11-dev:i386 python3.11-venv:i386"

          # Node.js
          "curl -fsSL https://deb.nodesource.com/setup_24.x | sudo -E bash -"
          "sudo apt-get install -y nodejs"

          # Install PNPM
          "sudo corepack enable"
          "sudo corepack prepare pnpm@latest --activate"

          # Install C++ Build Tools
          "sudo apt-get install -y nodejs build-essential gcc-multilib g++-multilib libgtk-3-dev:i386 ninja-build pkg-config:i386"
          
          # Install libs
          "sudo apt-get install -y ${lib.concatStringsSep " " headerOnlyLibs} ${lib.concatStringsSep " " binaryLibs}"
        ];
      };
    };
  };
}