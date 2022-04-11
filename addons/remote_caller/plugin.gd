tool
extends EditorPlugin

const _INSPECTOR_PLUGIN = preload("res://addons/remote_caller/inspector_plugin.gd")
var _inspector_plugin: EditorInspectorPlugin

func _enter_tree():
	_inspector_plugin = _INSPECTOR_PLUGIN.new()
	add_inspector_plugin(_inspector_plugin)

func _exit_tree():
	if _inspector_plugin:
		remove_inspector_plugin(_inspector_plugin)
