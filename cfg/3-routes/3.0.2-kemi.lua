-- ksr_request_route - Main route for incoming requests
function ksr_request_route()
    KSR.xlog.xlog("L_INFO", "=== LUA REQUEST_ROUTE ===\n")
    KSR.xlog.xlog("L_INFO", "Method: " .. KSR.pv.get("$rm") .. " | URI: " .. KSR.pv.get("$ru") .. "\n")
    KSR.xlog.xlog("L_INFO", "From: " .. KSR.pv.get("$fu") .. " | Source: " .. KSR.pv.get("$si") .. ":" .. KSR.pv.get("$sp") .. "\n")

    -- Set transaction to use named reply route
    KSR.tm.t_on_reply("ksr_onreply_custom")

    -- Handle OPTIONS locally
    local method = KSR.pv.get("$rm")
    if method == "OPTIONS" then
        KSR.xlog.xlog("L_INFO", "Handling OPTIONS in Lua\n")
        KSR.sl.sl_send_reply(200, "OK - Lua Route")
        return 1
    end

    -- For testing without backend, send reply
    KSR.sl.sl_send_reply(200, "Processed by Lua Route")
    return 1
end


-- ksr_reply_route - Runs for ALL replies (executed first)
function ksr_reply_route()
    KSR.xlog.xlog("L_INFO", "=== LUA REPLY_ROUTE (Global) ===\n")
    KSR.xlog.xlog("L_INFO", "Status: " .. KSR.pv.get("$rs") .. " " .. KSR.pv.get("$rr") .. " | Method: " .. KSR.pv.get("$rm") .. "\n")
    KSR.xlog.xlog("L_INFO", "Reply from: " .. KSR.pv.get("$si") .. ":" .. KSR.pv.get("$sp") .. "\n")
    return 1
end


-- ksr_onreply_custom - Named reply route (runs after ksr_reply_route)
function ksr_onreply_custom()
    KSR.xlog.xlog("L_INFO", "=== LUA ONREPLY_ROUTE[CUSTOM] ===\n")
    KSR.xlog.xlog("L_INFO", "Custom Lua handling for reply: " .. KSR.pv.get("$rs") .. " " .. KSR.pv.get("$rr") .. "\n")

    -- Add custom header to reply
    KSR.hdr.append("X-Kamailio-Route: Lua\r\n")
    return 1
end
