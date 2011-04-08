require "cookies"

-- Convert glob into lua regex
local function mkglob(pat)
    pat = string.gsub(pat, "[%^%$%(%)%%%.%[%]%+%-%?]", "%%%1")
    return string.gsub(pat, "*", "%%S*")
end

local function parse_rule(rules, line)
    local domain, path, name
    local last

    -- Add new rule
    function add()
        -- Ignore all blank domain/path/name vars
        if (not domain and not path and not name) then return end

        -- Make combined pattern
        local pat = "^" .. mkglob(string.format("%s %s %s", domain or "*",
                path or "*", name or "*")) .. "$"

        -- Check for immediate duplicates
        if pat == last then return end

        -- Add rule
        table.insert(rules, pat)
        print(" > " .. pat)
        last = pat
    end

    local token_order = { d = 1, p = 2, n = 3 }
    local lorder, order = 0
    string.gsub(line, "%s*(~?)([dpn])(%S+)", function (skip_add, t, value)
        order = token_order[t]
        skip_add = (skip_add == "~")

        -- User used same field twice, add partial rule
        if not skip_add and last_order == order then
            add()
        end

        -- Update values
        if     t == "d" then domain = value
        elseif t == "p" then path   = value
        elseif t == "n" then name   = value end

        if not skip_add and ((order <= lorder) or
                (t == "n" and domain and path)) then
            add()
        end

        lorder = order
    end)

    add()
end

-- Cookie matching cache
-- TODO: Put in some safeguards to prevent this accumulating an inf
-- number of items
local cache

local function load_rules(file)
    print("Looking for file: ", file)
    if os.exists(file) then
        print("Loading: ", file)
        rules = {}
        for line in io.lines(file) do
            -- Ignore comments
            if not string.find(line, "^#") then
                print(" < " .. line)
                parse_rule(rules, line)
            end
        end
        cache = nil
        return rules
    end
end

-- Set default whitelist/blacklist paths
cookies.whitelist = luakit.config_dir .. '/cookie.whitelist'
cookies.blacklist = luakit.config_dir .. '/cookie.blacklist'

-- Whitelist/blacklist pattern tables
local whitelist, blacklist

-- Reload whitelist/blacklists
function cookies.reload_lists()
    cache = nil
    whitelist = load_rules(luakit.config_dir .. '/cookie.whitelist')
    blacklist = load_rules(luakit.config_dir .. '/cookie.blacklist')
end

local function match_cookie(rules, cookie)
    for _, pat in ipairs(rules) do
        if string.match(cookie, pat) then return true end
    end
end

cookies.add_signal("accept-cookie", function (c)
    if not cache then cache = {} end

    -- Join cookie domain, path and name for easy matching
    local cookie = string.format("%s %s %s", c.domain, c.path or '/', c.name)
    print("Attempting to match: ", cookie)

    -- Return cached result
    if cache[cookie] ~= nil then
        print("CACHE " .. (cache[cookie] and "ALLOW" or "DENY"))
        return cache[cookie]
    end

    -- Check if cookie{domain,path,name} in whitelist
    if whitelist and whitelist[1] then
        if match_cookie(whitelist, cookie) then
            cache[cookie] = true
            print("ALLOW")
            return true
        end
    end

    -- Check if cookie{domain,path,name} in blacklist
    if blacklist and blacklist[1] then
        if match_cookie(blacklist, cookie) then
            cache[cookie] = false
            print("DENY")
            return false
        end
    end

    print("DEFAULT ALLOW")
end)

-- Load initial whitelist/blacklist rules
cookies.reload_lists()
