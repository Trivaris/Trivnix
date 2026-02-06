osConfig:
let
  scheme = osConfig.themingPrefs.scheme;
in
''
# The basic colors
foreground              ${scheme.base05}
background              ${scheme.base00}
selection_foreground    ${scheme.base00}
selection_background    ${scheme.base02}

# Cursor colors
cursor                  ${scheme.base05}
cursor_text_color       ${scheme.base00}

# URL underline color when hovering with mouse
url_color               ${scheme.base04}

# Kitty window border colors
active_border_color     ${scheme.base03}
inactive_border_color   ${scheme.base01}
bell_border_color       ${scheme.base0A}

# OS Window titlebar colors
wayland_titlebar_color system
macos_titlebar_color system

# Tab bar colors
active_tab_foreground   ${scheme.base00}
active_tab_background   ${scheme.base0D}
inactive_tab_foreground ${scheme.base05}
inactive_tab_background ${scheme.base01}
tab_bar_background      ${scheme.base01}

# Colors for marks (marked text in the terminal)
mark1_foreground ${scheme.base00}
mark1_background ${scheme.base0D}
mark2_foreground ${scheme.base00}
mark2_background ${scheme.base0E}
mark3_foreground ${scheme.base00}
mark3_background ${scheme.base0C}

# The 16 terminal colors

# black
color0 ${scheme.base00}
color8 ${scheme.base03}

# red
color1 ${scheme.base08}
color9 ${scheme.base08}

# green
color2  ${scheme.base0B}
color10 ${scheme.base0B}

# yellow
color3  ${scheme.base0A}
color11 ${scheme.base0A}

# blue
color4  ${scheme.base0D}
color12 ${scheme.base0D}

# magenta
color5  ${scheme.base0E}
color13 ${scheme.base0E}

# cyan
color6  ${scheme.base0C}
color14 ${scheme.base0C}

# white
color7  ${scheme.base05}
color15 ${scheme.base07}
''