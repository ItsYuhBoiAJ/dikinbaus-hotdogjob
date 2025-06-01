fx_version 'cerulean'
game 'gta5'
lua54 'yes'

author 'AyeJay'
description 'Dikinbaus Hotdog Job - Sell hotdogs to NPCs at Dikinbaus in Roxwood'
version '1.3.0'

ui_page 'html/ui.html'

shared_scripts {
    '@qb-core/shared/locale.lua',
    'locales/en.lua',
    'locales/*.lua',
    'config.lua'
}

client_scripts {
    '@PolyZone/client.lua',
    '@PolyZone/BoxZone.lua',
    '@PolyZone/EntityZone.lua',
    'client.lua'
}

server_script 'server.lua'

files {
    'html/ui.html',
    'html/ui.css',
    'html/ui.js',
    'html/icon.png'
}
