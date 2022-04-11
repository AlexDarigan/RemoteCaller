extends EditorInspectorPlugin

func can_handle(object: Object) -> bool:
	# We cannot test against this class directly
	# This string doesn't change even if the editor language does
	# This string represents anything that opens in the Inspector
	# when pressed in the remote scene tree inspector
	return "ScriptEditorDebuggerInspectedObject" in str(object)
	
func parse_begin(object) -> void:
	var remote_id: int = object.get_remote_object_id()
	if object.get_script():
		add_property_editor("Remote Caller", CallableEditorProperty.new(object.get_script().get_script_method_list()))


