extends Node

export(Vector3) var vec3

export(Dictionary) var my_dict

func my_first_game_func() -> void:
	print("calling my first game func from ", name)
	
func my_second_game_func() -> void:
	print("calling my second game func from ", name)
