extends "res://Game.gd"

# warning-ignore:unused_signal
signal my_child_signal

func _ready():
# warning-ignore:return_value_discarded
	connect("my_child_signal", self, "_child_callback")

func my_subgame_func() -> void:
	print("calling my_subgame_func from ", name)

func _child_callback():
	print("child callback from child signal")
	
func _parent_callback():
	print("parent callback overriden in child")
