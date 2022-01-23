require "apache2"

local urlencode = function(s)
    s = string.gsub(s, "(\r\n?)", "\n")
    s = string.gsub(s, "\n", "\r\n")
    s = string.gsub(s, "([^0-9a-zA-Z%%&+.=_~-])", function(c)
        return string.format("%%%02X", string.byte(c))
    end)
    return s
end

function fix_url_params(r)
    local query = r.args
    if query ~= nil and string.find(query, "[^0-9a-zA-Z%%&+.=_~-]") ~= nil then
        r.args = urlencode(query)
    end

    return apache2.DECLINED
end

function fix_body_params_filter(r)
    if (r.method == "POST" or r.method == "PUT" or r.method == "DELETE") and
        string.lower(r.headers_in['Content-Type']) == "application/x-www-form-urlencoded" then
        coroutine.yield()
        while bucket ~= nil do
            coroutine.yield(urlencode(bucket))
        end
        coroutine.yield()
    end
end
