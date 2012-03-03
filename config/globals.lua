-- Global variables for luakit
globals = {
    homepage            = "about:blank",
 -- homepage            = "http://github.com/mason-larobina/luakit",
    scroll_step         = 40,
    zoom_step           = 0.1,
    max_cmd_history     = 100,
    max_srch_history    = 100,
 -- http_proxy          = "http://example.com:3128",
    default_window_size = "800x600",

 -- Disables loading of hostnames from /etc/hosts (for large host files)
 -- load_etc_hosts      = false,
 -- Disables checking if a filepath exists in search_open function
 -- check_filepath      = false,
}

-- Make useragent
local _, arch = luakit.spawn_sync("uname -sm")
-- Only use the luakit version if in date format (reduces identifiability)
local lkv = string.match(luakit.version, "^(%d+.%d+.%d+)")
globals.useragent = string.format("Mozilla/5.0 (%s) AppleWebKit/%s+ (KHTML, like Gecko) WebKitGTK+/%s luakit%s",
    string.sub(arch, 1, -2), luakit.webkit_user_agent_version,
    luakit.webkit_version, (lkv and ("/" .. lkv)) or "")

-- Search common locations for a ca file which is used for ssl connection validation.
local ca_files = {
    -- $XDG_DATA_HOME/luakit/ca-certificates.crt
    luakit.data_dir .. "/ca-certificates.crt",
    "/etc/certs/ca-certificates.crt",
    "/etc/ssl/certs/ca-certificates.crt",
}
-- Use the first ca-file found
for _, ca_file in ipairs(ca_files) do
    if os.exists(ca_file) then
        soup.ssl_ca_file = ca_file
        break
    end
end

-- Change to stop navigation sites with invalid or expired ssl certificates
soup.ssl_strict = false

-- Set cookie acceptance policy
cookie_policy = { always = 0, never = 1, no_third_party = 2 }
soup.accept_policy = cookie_policy.always

-- List of search engines. Each item must contain a single %s which is
-- replaced by URI encoded search terms. All other occurances of the percent
-- character (%) may need to be escaped by placing another % before or after
-- it to avoid collisions with lua's string.format characters.
-- See: http://www.lua.org/manual/5.1/manual.html#pdf-string.format
search_engines = {
    g           = "http://google.com/search?q=%s",
    l           = "http://google.com/search?q=%s&btnI=I'm+Feeling+Lucky",
    w           = "http://en.wikipedia.org/wiki/Special:Search?search=%s",
    d           = "http://dictionary.reference.com/browse/%s",
    s           = "http://duckduckgo.com/?q=%s",
    sl          = "http://duckduckgo.com/?q=! %s",
}

-- Set google as fallback search engine
search_engines.default = search_engines.sl
-- Use this instead to disable auto-searching
--search_engines.default = "%s"

-- Per-domain webview properties
-- See http://webkitgtk.org/reference/webkitgtk-WebKitWebSettings.html
domain_props = {
    ["all"] = {
        ["zoom_level"]              = 2,
        ["full_content_zoom"]       = true,
        ["enable_scripts"]          = true,
        ["enable_plugins"]          = false,
    },
    ["mail.google.com"] = {
        ["user_stylesheet_uri"]     = "file:///root/.config/luakit/gmail.css",
    },
--[[
    ["all"] = {
        enable_scripts          = false,
        enable_plugins          = false,
        enable_private_browsing = false,
        user_stylesheet_uri     = "",
    },
    ["youtube.com"] = {
        enable_scripts = true,
        enable_plugins = true,
    },
    ["bbs.archlinux.org"] = {
        user_stylesheet_uri     = "file://" .. luakit.data_dir .. "/styles/dark.css",
        enable_private_browsing = true,
    }, ]]
}

globals.go_next_prev = {
-- default settings
 --  next = [[(\bnext\b|^>$|^(>>|»)$|^(>|»)|(>|»)$|\bmore\b)]],
 --  prev = [[(\b(prev|previous)\b|^<$|^(<<|«)$|^(<|«)|(<|«)$)]],
-- domains specific settings
 -- ["google.com"] = {next = "Next", prev = "Previous"},
}

-- vim: et:sw=4:ts=8:sts=4:tw=80
