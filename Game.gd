extends Node

func my_first_game_func() -> void:
	print("calling my first game func from ", name)
	
func my_second_game_func() -> void:
	print("calling my second game func from ", name)
	
func my_param_func(a, b) -> void:
	print(a + b, " woohoo for params!")
