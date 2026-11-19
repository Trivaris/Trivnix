{
  flake.nixosModules.system-core =
    { config, ... }:
    let
      hostTheming = config.host.theming;
    in
    {
      config = {
        qt.enable = true;

        fonts = {
          enableDefaultPackages = true;
          packages = [ hostTheming.font.package ] ++ hostTheming.font.extraFonts;
          fontconfig = {
            enable = true;
            useEmbeddedBitmaps = true;
            defaultFonts = {
              emoji = [ "Noto Color Emoji" ];
              monospace = [ hostTheming.font.monoName ];
              sansSerif = [ hostTheming.font.propoName ];
              serif = [ hostTheming.font.propoName ];
            };
          };
        };
      };
    };
}
