tool
extends EditorPlugin

const _INSPECTOR_PLUGIN = preload("res://addons/remote_caller/inspector_plugin.gd")
var _inspector_plugin: EditorInspectorPlugin


func _enter_tree():
	_inspector_plugin = _INSPECTOR_PLUGIN.new()
	add_inspector_plugin(_inspector_plugin)
	add_autoload_singleton("RemoteCallerServer", "res://addons/remote_caller/network/game_server.gd")
	add_autoload_singleton("RemoteCallerClient", "res://addons/remote_caller/network/editor_client.gd")


func _exit_tree():
	if _inspector_plugin:
		remove_inspector_plugin(_inspector_plugin)
	remove_autoload_singleton("RemoteCallerServer")
	remove_autoload_singleton("RemoteCallerClient")
