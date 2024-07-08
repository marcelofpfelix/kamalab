function ksr_request_route()
    KSR.pv.sets("$var(name)", "Hello, World!");

    KSR.sl.sl_send_reply(200, KSR.pv.get("$var(name)"))
end
