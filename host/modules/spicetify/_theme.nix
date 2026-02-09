config: pkgs:
let
  scheme = config.themingPrefs.scheme;
  getColor = str: pkgs.lib.removePrefix "#" str;
in
{
  name = "custom-16bit";
  src = pkgs.writeTextDir "color.ini" ''
    [Base]

    [Custom]
    text               = ${getColor scheme.base05}
    subtext            = ${getColor scheme.base04}
    main               = ${getColor scheme.base00}
    sidebar            = ${getColor scheme.base00}
    player             = ${getColor scheme.base00}
    card               = ${getColor scheme.base01}
    shadow             = ${getColor scheme.base00}
    selected-row       = ${getColor scheme.base02}
    button             = ${getColor scheme.base0D}
    button-active      = ${getColor scheme.base05}
    button-disabled    = ${getColor scheme.base03}
    tab-active         = ${getColor scheme.base0D}
    notification       = ${getColor scheme.base01}
    notification-error = ${getColor scheme.base08}
    misc               = ${getColor scheme.base01}
  '';
}
