{
  inputs,
  pkgs
}:
pkgs.buildGoModule {
  pname = "udp-proxy-2020";
  version = "v0.0.11";

  src = pkgs.fetchFromGitHub {
    owner = "synfinatic";
    repo = "udp-proxy-2020";
    rev = "72742faabb019146a41e0551fc29f9a77fc631e5";
    sha256 = "sha256-78vOnu5RZgIR71x8fXbWmoeRDzRgaZBQXJ6nugLNij0=";
  };

  nativeBuildInputs = [ pkgs.makeWrapper ];
  buildInputs = with pkgs; [ gcc gnumake libpcap ];

  vendorHash = "sha256-D5VyJx76B39KgQ8m9uTmp1vgkyClWq5VQh2iWE+PwaI=";


  meta = with pkgs.lib; {
    description = "UDP Proxy 2020";
    homepage = "https://github.com/synfinatic/udp-proxy-2020";
    license = licenses.mit;
  };
}
