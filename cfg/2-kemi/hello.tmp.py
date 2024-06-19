## Kamailio - equivalent of routing blocks in Python
import sys
import Router.Logger as Logger
import KSR as KSR

# global function to instantiate a kamailio class object
# -- executed when kamailio app_python module is initialized
def mod_init():
    KSR.warn("===== from Python mod init\n");
    return kamailio();


# -- {start defining kamailio class}
class kamailio:
    def __init__(self):
        KSR.warn('===== kamailio.__init__\n');


    # executed when kamailio child processes are initialized
    def child_init(self, rank):
        KSR.warn('===== kamailio.child_init(%d)\n' % rank);
        return 0;


    # SIP request routing
    # -- equivalent of request_route{}
    def ksr_request_route(self, msg):
        KSR.warn("===== request - from kamailio python script\n");
        KSR.warn("===== method [%s] r-uri [%s]\n" % (KSR.pv.get("$rm"),KSR.pv.get("$ru")));
