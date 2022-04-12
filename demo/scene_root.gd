extends Label

var _called: int = 0
# warning-ignore:unused_signal
signal _callback_scene_root_with_params

func _ready() -> void:
	connect("_callback_scene_root_with_params", self, "_on_callback_scene_root_with_params")

func call_scene_root() -> void:
	_called += 1
	set_text("Called " + str(_called) + " times")
	
func call_scene_root_with_params(text: String) -> void:
	set_text(text)
	
func _on_callback_scene_root_with_params(text: String) -> void:
	set_text(text)
