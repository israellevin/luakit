--------------------------
-- Default luakit theme --
--------------------------

local theme = {}

-- Default settings
theme.font = "monospace normal 20"
theme.fg   = "#fff"
theme.bg   = "#000"

-- Genaral colours
theme.success_fg = "#0f0"
theme.loaded_fg  = "#33AADD"
theme.error_fg = "#FFF"
theme.error_bg = "#F00"

-- Warning colours
theme.warning_fg = "#F00"
theme.warning_bg = "#FFF"

-- Notification colours
theme.notif_fg = "#444"
theme.notif_bg = "#FFF"

-- Menu colours
theme.menu_fg                   = "#000"
theme.menu_bg                   = "#fff"
theme.menu_selected_fg          = "#000"
theme.menu_selected_bg          = "#FF0"
theme.menu_title_bg             = "#fff"
theme.menu_primary_title_fg     = "#f00"
theme.menu_secondary_title_fg   = "#666"

-- Proxy manager
theme.proxy_active_menu_fg      = '#000'
theme.proxy_active_menu_bg      = '#FFF'
theme.proxy_inactive_menu_fg    = '#888'
theme.proxy_inactive_menu_bg    = '#FFF'

-- Statusbar specific
theme.sbar_fg         = "#0f0"
theme.sbar_bg         = "#000"

-- Downloadbar specific
theme.dbar_fg         = "#fff"
theme.dbar_bg         = "#000"
theme.dbar_error_fg   = "#f00"

-- Input bar specific
theme.ibar_fg           = "#000"
theme.ibar_bg           = "#0f0"

-- Tab label
theme.tab_fg            = "#888"
theme.tab_bg            = "#222"
theme.tab_ntheme        = "#ddd"
theme.selected_fg       = "#fff"
theme.selected_bg       = "#000"
theme.selected_ntheme   = "#ddd"
theme.loading_fg        = "#33AADD"
theme.loading_bg        = "#000"

-- Trusted/untrusted ssl colours
theme.trust_fg          = "#050"
theme.notrust_fg        = "#F00"

theme.follow = {
    focus_bg      = "#00ff00";
    normal_bg     = "#ffff99";
    opacity       = 0.5;
    border        = "1px dotted #000000";
    frame_border  = "2px solid #880000";
    tick_frame_bg = "#880000";
    tick_fg       = "#ffff99";
    tick_bg       = "#000088";
    tick_border   = "2px dashed #000000";
    tick_opacity  = 0.5;
    tick_font     = "16px monospace bold";
    vert_offset   = 10;
    horiz_offset  = 0;
}

return theme
-- vim: et:sw=4:ts=8:sts=4:tw=80
