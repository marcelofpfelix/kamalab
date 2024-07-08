#!KAMAILIO

#!define KEMI_MOD "{{.KEMI_MOD }}"

#!ifexp KEMI_MOD != "app_inc.cfg"

loadmodule KEMI_MOD
modparam(KEMI_MOD, "load", "{{.KAMA_INC }}")
cfgengine "{{.KEMI_ENG }}"

#!else

// envtpl dependency since include does not support define
#!include_file "{{.KAMA_INC }}"

#!endif
