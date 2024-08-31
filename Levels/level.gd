extends Node2D

signal start_game
signal stop_game

@onready var mothership_point: Marker2D = $MothershipPoint
@onready var lives: Array[Node] = $Control/LiveDisplay.get_children()
@onready var starting_position: Vector2 = $EnemiesSpawn.position
@onready var enemy_data := [
	{ "type": ENEMY_1, "rows": 2, "cols": 10, "start_pos": starting_position, "id": 3 },
	{ "type": ENEMY_2, "rows": 2, "cols": 10, "start_pos": starting_position + Vector2(0, 50), "id": 2}, 
	{ "type": ENEMY_3, "rows": 2, "cols": 10, "start_pos": starting_position + Vector2(0, 100), "id": 1 }
]

const MOTHERSHIP = preload("res://Enemies/Mothership/Mothership.tscn")
const ENEMY_1 = preload("res://Enemies/BaseEnemies/Enemy1.tscn")
const ENEMY_2 = preload("res://Enemies/BaseEnemies/Enemy2.tscn")
const ENEMY_3 = preload("res://Enemies/BaseEnemies/Enemy3.tscn")

var chance: float
var isMothershipPresent: bool = false
var shipsInPlace: bool = false

func _ready() -> void:
	$Control/Lost.hide()
	$Control/HighScore.text += str(Global.save_data.high_score)
	$Control/Champion.text += Global.save_data.champion
	$Control/Lost/ChampionInput.hide()
	
	if Global.cuadrazo_edition:
		$AudioStreamPlayer2D.play()
	else:
		$Incoming.queue_free()
		$HiveMind.spawn_enemies(enemy_data)

func _physics_process(_delta: float) -> void:
	$Control/Score.text = "Score:  " + str(Global.score)
	isMothershipPresent = get_children().map(getMotherships).any(func (b: bool) -> bool: return b);
	var rng := RandomNumberGenerator.new()
	chance = rng.randf_range(0, 1.0)
	shouldSpawnMothership()
	
	if shipsInPlace && $HiveMind.get_children().filter(is_enemy).size() == 0:
		shipsInPlace = false
		restart_game()
	
func shouldSpawnMothership() -> void:
	if(chance < Global.chance_of_ufo && !isMothershipPresent && shipsInPlace):
		spawnMothership()

func spawnMothership() -> void:
	var mothership = MOTHERSHIP.instantiate()
	mothership.position = mothership_point.position
	add_child(mothership)

func getMotherships(c: Node) -> bool: 
	return c is Mothership
	
func getProjectiles(c: Node) -> bool: 
	return c is Laser or c is Projectile

func _on_player_player_death() -> void:
	get_children().filter(getProjectiles).map(func (n: Node) -> void: n.queue_free())
	if Global.lives > 0:
		Global.lives -= 1
		lives[Global.lives].visible = false
		freeze_start()
		$Player.respawn($PlayerSpawn)
	else:
		get_tree().paused = true
		$Control/Lost.show()
		if Global.is_new_hi_score():
			$Control/Lost/ChampionInput.show()
			$Control/Lost/ChampionInput/LineEdit.grab_focus()

func freeze_start() -> void:
	start_game.emit()
	# Freeze the game
	$Control/GetReady.visible = true
	$StartTimer.start()
	get_tree().paused = true
	await $StartTimer.timeout
	get_tree().paused = false
	$Control/GetReady.visible = false

func restart_game() -> void:
	Global.aggression_increase()
	stop_game.emit()
	$HiveMind.spawn_enemies(enemy_data)
	
func _on_hive_mind_ships_in_place() -> void:
	shipsInPlace = true
	for enemy in $HiveMind.get_children().filter(is_enemy):
		enemy.start_ship()
	# Wait til ships are in place
	freeze_start()

func is_enemy(node) -> bool:
	return node is Enemy 

func _on_button_pressed() -> void:
	$Control/Lost.hide()
	get_tree().paused = false
	get_tree().reload_current_scene()

func _on_save_input_pressed() -> void:
	var player_name = $Control/Lost/ChampionInput/LineEdit.text
	
	if player_name.strip_edges() != "":
		Global.save_hi_score(player_name)
	else:
		Global.save_hi_score("Anonymous")
	$Control/Lost/ChampionInput.hide()

func _on_audio_stream_player_2d_finished() -> void:
	$Incoming.queue_free()
	$HiveMind.spawn_enemies(enemy_data)

func _on_final_area_body_entered(body: Node2D) -> void:
	if body is Enemy:
		get_tree().paused = true
		$Control/Lost/Lose.text = "Failed to stop invasion"

		$Control/Lost.show()
		if Global.is_new_hi_score():
			$Control/Lost/ChampionInput.show()
			$Control/Lost/ChampionInput/LineEdit.grab_focus()
