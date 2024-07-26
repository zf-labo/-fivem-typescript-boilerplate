fx_version 'cerulean'
game 'gta5'
lua54 'yes'

author 'LeZach'
description ''
version '1.0.0'

client_scripts {
    'bridge/client.lua',
    'build/client/*.js',
}

server_scripts {
    'bridge/server.lua',
    'build/server/*.js',
}

shared_scripts {
    '@ox_lib/init.lua',
    'build/shared/*.js',
}

files {
    'locales/*.json',
    'data/*.json',
    'bridge/**/*.lua',
}