extends EditorProperty
class_name CallableEditorProperty

# These are special engine callbacks that should not be manually invoked!
const _ENGINE_CALLBACKS = ["_init", "_enter_tree", "_ready", "_process", "_physics_process", "_exit_tree"]

const CallBox: PackedScene = preload("res://addons/remote_caller/CallBox.tscn")
var _callbox: Control = CallBox.instance()
var _callables: OptionButton
var _remote_object_id: int
var _make_call: FuncRef

func _init(object, remote_object_id: int, methods: Array) -> void:
	label = "Remote Caller"
	_remote_object_id = remote_object_id
	_callables = _callbox.get_node("Callables")
	_callbox.get_node("CallButton").connect("pressed", self, "_on_call_button_pressed")
	
	for method in methods:
		if not _ENGINE_CALLBACKS.has(method.name):
			_callbox.get_node("Callables").add_item(method.name)
	
	add_child(_callbox)
	set_bottom_editor(_callbox)

func _ready() -> void:
	_make_call = funcref(get_tree().root.get_node("RemoteCallerClient"), "make_call")

func _on_call_button_pressed() -> void:
	_make_call.call_func(_remote_object_id, _get_selected_function())
	
func _get_selected_function() -> String:
	return _callables.get_item_text(_callables.get_selected_id())
	
func _exit_tree() -> void:
	remove_child(_callbox)
	_callbox.queue_free()

