extends Node

@export var score := 0
@export var lives := 3
@export var chance_of_ufo := 0.005

func _process(_delta) -> void:
	pass

func game_over() -> void:
	pass
	
func save_hi_score() -> void:
	pass

func is_new_hi_score() -> void:
	pass

func update_score(num: int) -> void:
	score += num
