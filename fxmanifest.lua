fx_version "cerulean"
lua54 "yes"
game "gta5"

author "Nitesam"
description "Sistema di Furto in Casa creato da Nitesam per E-Life"

shared_script {
    "config.lua",
    "@ox_lib/init.lua",
    "@es_extended/imports.lua"
}

client_scripts {
    "client/*.lua"
}

server_scripts {
    "server/*.lua"
}

dependency {
    "ox_lib",
    "ox_target",
    "es_extended"
}