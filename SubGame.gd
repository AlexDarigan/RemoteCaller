extends "res://Game.gd"

func my_subgame_func() -> void:
	print("calling my_subgame_func from ", name)

func _ready():
	set_meta("my_data", "somedata")
