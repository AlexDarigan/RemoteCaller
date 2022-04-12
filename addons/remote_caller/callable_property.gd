extends EditorProperty
class_name CallableEditorProperty

# These are special engine callbacks that should not be manually invoked!
const _ENGINE_CALLBACKS = ["_init", "_enter_tree", "_ready", "_process", "_physics_process", "_exit_tree"]
const _FUNCTION_ICON: Texture = preload("res://addons/remote_caller/icons/function.png")
const _SIGNAL_ICON: Texture = preload("res://addons/remote_caller/icons/MemberSignal.svg")
const CallBox: PackedScene = preload("res://addons/remote_caller/CallBox.tscn")
var _callbox: Control = CallBox.instance()
var _callables: OptionButton
var _remote_object_id: int
var _make_call: FuncRef


func _init(object: Object) -> void:
	label = "Remote Caller"
	_remote_object_id = object.get_remote_object_id()
	_callables = _callbox.get_node("Callables")
	_callbox.get_node("CallButton").connect("pressed", self, "_on_call_button_pressed")
	_callbox.get_node("AddParam").connect("pressed", self, "_on_add_params_pressed")
	
	for method in object.get_script().get_script_method_list():
		if not _ENGINE_CALLBACKS.has(method.name):
			_callbox.get_node("Callables").add_icon_item(_FUNCTION_ICON, method.name)
			
	for event in object.get_script().get_script_signal_list():
		_callbox.get_node("Callables").add_icon_item(_SIGNAL_ICON, event.name)
	
	add_child(_callbox)
	set_bottom_editor(_callbox)

func _ready() -> void:
	_make_call = funcref(get_tree().root.get_node("RemoteCallerClient"), "make_call")
	get_tree().root.get_node("RemoteCallerClient").call("add_parameters", _remote_object_id)
	
func _on_call_button_pressed() -> void:
	_make_call.call_func(_remote_object_id, _get_call_type(), _get_selected_callable())
	
func _get_selected_callable() -> String:
	return _callables.get_item_text(_callables.get_selected_id())
	
func _get_call_type():
	return "function" if _callables.get_item_icon(_callables.get_selected_id()) == _FUNCTION_ICON else "signal"
	
func _exit_tree() -> void:
	remove_child(_callbox)
	_callbox.queue_free()

