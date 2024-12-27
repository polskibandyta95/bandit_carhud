shared_script '@virtual_custombronie/shared_fg-obfuscated.lua'
resource_manifest_version '44febabe-d386-4d18-afbe-5e627f4af937'

description 'Virtual Speedo'

client_script 'client.lua'

server_script 'server.lua'

ui_page 'ui/index.html'

files {
    'ui/index.html',
    'ui/style.css',
    'ui/script.js',
	'ui/icons/doors.png',
    'ui/icons/seatbelt.png',
    'ui/icons/engine.png',
	'ui/icons/engineicon.png',
	'ui/icons/fuelicon.png',
	'ui/icons/gear.png',
	'ui/fonts/Gilroy-Bold.woff',
	'ui/fonts/Gilroy-Regular.woff'
}
