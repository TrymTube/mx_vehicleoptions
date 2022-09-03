fx_version 'bodacious'
game 'gta5'

author 'Max'
description 'easy way to change your vehicle appearance'
version '1.1.0'

lua54 'on'

shared_script {
	'@es_extended/imports.lua',
	'config.lua'
}

client_scripts {
	'NativeUI.lua',
	'client/*.lua'
}

server_scripts {
	'server/*.lua'
}