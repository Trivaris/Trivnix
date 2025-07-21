pkgs:
hex:
let
  script = pkgs.writeShellScript "hex2b64" ''
    echo -n '${hex}' | xxd -r -p | openssl base64 -A
  '';
in
builtins.readFile (pkgs.runCommand "hex-to-b64" {
  nativeBuildInputs = [ pkgs.openssl pkgs.unixtools.xxd ];
} ''
  ${script} > $out
'')