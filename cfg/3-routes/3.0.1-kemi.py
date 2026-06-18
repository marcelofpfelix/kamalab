import KSR as KSR

# ksr_request_route - Main route for incoming requests
def ksr_request_route():
    KSR.xlog.xlog("L_INFO", "=== PYTHON REQUEST_ROUTE ===\n")
    KSR.xlog.xlog("L_INFO", f"Method: {KSR.pv.get('$rm')} | URI: {KSR.pv.get('$ru')}\n")
    KSR.xlog.xlog("L_INFO", f"From: {KSR.pv.get('$fu')} | Source: {KSR.pv.get('$si')}:{KSR.pv.get('$sp')}\n")

    # Set transaction to use named reply route
    KSR.tm.t_on_reply("ksr_onreply_custom")

    # Handle OPTIONS locally
    method = KSR.pv.get("$rm")
    if method == "OPTIONS":
        KSR.xlog.xlog("L_INFO", "Handling OPTIONS in Python\n")
        KSR.sl.sl_send_reply(200, "OK - Python Route")
        return 1

    # For testing without backend, send reply
    KSR.sl.sl_send_reply(200, "Processed by Python Route")
    return 1


# ksr_reply_route - Runs for ALL replies (executed first)
def ksr_reply_route():
    KSR.xlog.xlog("L_INFO", "=== PYTHON REPLY_ROUTE (Global) ===\n")
    KSR.xlog.xlog("L_INFO", f"Status: {KSR.pv.get('$rs')} {KSR.pv.get('$rr')} | Method: {KSR.pv.get('$rm')}\n")
    KSR.xlog.xlog("L_INFO", f"Reply from: {KSR.pv.get('$si')}:{KSR.pv.get('$sp')}\n")
    return 1


# ksr_onreply_custom - Named reply route (runs after ksr_reply_route)
def ksr_onreply_custom():
    KSR.xlog.xlog("L_INFO", "=== PYTHON ONREPLY_ROUTE[CUSTOM] ===\n")
    KSR.xlog.xlog("L_INFO", f"Custom Python handling for reply: {KSR.pv.get('$rs')} {KSR.pv.get('$rr')}\n")

    # Add custom header to reply
    KSR.hdr.append("X-Kamailio-Route: Python\r\n")
    return 1
