fx_version 'bodacious'
game 'gta5'

author 'Max'
description 'easy way to change your vehicle appearance'
version '0.1'

lua54 'on'

shared_script {
	'@es_extended/imports.lua',
	'@es_extended/locale.lua',
	'config.lua'
}

client_scripts {
	'@NativeUI/NativeUI.lua',
	'client/*.lua'
}

server_scripts {
	'server/*.lua'
}