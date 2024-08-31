extends Node

@export var score := 0
@export var lives := 3
@export var movement_speed := 1.0
@export var chance_of_ufo := 0.005
@export var enemy_ammo := 0.0002
@export var cuadrazo_edition := false

var save_data: SaveData

func _ready() -> void:
	save_data = SaveData.load_or_create()

func game_over() -> void:
	score = 0
	
func save_hi_score(champ: String) -> void:
	if is_new_hi_score():
		save_data.high_score = score
		save_data.champion = champ
		save_data.save()

func is_new_hi_score() -> bool:
	return score > save_data.high_score 

func update_score(num: int) -> void:
	score += num

func aggression_increase() -> void:
	enemy_ammo += 0.0002
	chance_of_ufo += 0.001

	if movement_speed > 0.2:
		movement_speed -= 0.2
