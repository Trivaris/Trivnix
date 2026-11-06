{
  minecraftServers,
  fetchurl,

  version ? "26.2",
  fabric-loader-version ? "0.19.3",
  installer-version ? "1.1.2",
  hash ? "sha256-MB+DqsNrI/K8ZMxYVg7fmFM8+qMOU68AK6lQx19BALQ=",
}:
let
  url = "https://meta.fabricmc.net/v2/versions/loader/${version}/${fabric-loader-version}/${installer-version}/server/jar";
in
minecraftServers."vanilla-${builtins.replaceStrings [ "." ] [ "-" ] version}".overrideAttrs
  (oldAttrs: {
    src = fetchurl { inherit url hash; };
  })
