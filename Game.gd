extends Node

# warning-ignore:unused_signal
signal my_parent_signal

func _ready() -> void:
# warning-ignore:return_value_discarded
	connect("my_parent_signal", self, "_parent_callback")

func my_first_game_func() -> void:
	print("calling my first game func from ", name)
	
func my_second_game_func() -> void:
	print("calling my second game func from ", name)
	
func my_param_func(a, b) -> void:
	print(a + b, " woohoo for params!")

func _parent_callback() -> void:
	print("parent callback from parent signal")
