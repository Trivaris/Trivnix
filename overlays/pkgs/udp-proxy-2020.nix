{
  inputs,
  pkgs
}:
pkgs.buildGoModule {
  pname = "udp-proxy-2020";
  version = inputs.udp-proxy-2020-src.shortRev;

  src = inputs.udp-proxy-2020-src;

  nativeBuildInputs = [ pkgs.makeWrapper ];
  buildInputs = with pkgs; [ gcc gnumake libpcap ];

  vendorHash = "sha256-D5VyJx76B39KgQ8m9uTmp1vgkyClWq5VQh2iWE+PwaI=";


  meta = with pkgs.lib; {
    description = "UDP Proxy 2020";
    homepage = "https://github.com/synfinatic/udp-proxy-2020";
    license = licenses.mit;
  };
}
