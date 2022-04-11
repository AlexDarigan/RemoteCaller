extends EditorProperty
class_name CallableEditorProperty

# These are special engine callbacks that should not be manually invoked!
const _ENGINE_CALLBACKS = ["_init", "_enter_tree", "_ready", "_process", "_physics_process", "_exit_tree"]

const CallBox: PackedScene = preload("res://addons/remote_caller/CallBox.tscn")
var _callbox: Control = CallBox.instance()
var _callables: OptionButton

func _init(methods) -> void:
	label = "Remote Caller"
	_callables = _callbox.get_node("Callables")
	_callbox.get_node("CallButton").connect("pressed", self, "_on_call_button_pressed")
	
	for method in methods:
		if not _ENGINE_CALLBACKS.has(method.name):
			_callbox.get_node("Callables").add_item(method.name)
	
	add_child(_callbox)
	set_bottom_editor(_callbox)

func _on_call_button_pressed() -> void:
	print("Calling: ", _get_selected_function())
	
func _get_selected_function() -> String:
	return _callables.get_item_text(_callables.get_selected_id())

	
