fx_version 'cerulean'
game 'gta5'
lua54 'yes'

author 'fx'
description 'fxProgressBar'
version '1.1'

ui_page 'html/index.html'

client_script 'client.lua'

files {
    'html/*.*',
    'client.lua'
}

escrow_ignore {
    'client.lua',
    'html/*.*'
}

export 'ShowProgressBar'
export 'IsProgressActive'
