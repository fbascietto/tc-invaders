extends Node

signal ships_in_place

@onready var movement_timer: Timer = $MovementTimer
@onready var spawn_delay: Timer = $"../SpawnDelay"

var sounds := [AudioManager.FASTINVADER_4, AudioManager.FASTINVADER_3, AudioManager.FASTINVADER_2, AudioManager.FASTINVADER_1]
var current_sound := 0

# Boundary variables
var right_boundary: int
var left_boundary: int = 25

# Define movement step and direction
var move_distance := 10.0
var move_direction := Vector2(1, 0) # Moving right initially

# Direction changed flag
var changed: bool = false
var game_stopped: bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	right_boundary = get_viewport().size.x - 25

func _process(_delta: float) -> void:
	movement_timer.wait_time = Global.movement_speed

# Move enemies down after they hit the boundary and reverse direction
func move_enemies_down():
	for enemy in get_children():
		if enemy is Enemy:
			enemy.move_down(move_distance)
	AudioManager.play_sound(sounds[current_sound])
	update_current_sound()

func move_enemies():
	# Move enemies by a fixed amount each time the timer fires
	for enemy in get_children():
		if enemy is Enemy:
			enemy.move(move_distance, move_direction)
	AudioManager.play_sound(sounds[current_sound])
	update_current_sound()

func _on_movement_timer_timeout() -> void:
	if game_stopped:
		return
	
	if changed:
		changed = false
		move_enemies()
		return
	
		# Check if enemies reached the screen boundary
	if should_change_direction() && !changed:
		move_direction.x *= -1
		move_enemies_down()
		changed = true
		return
		
	move_enemies()

# Function to check if enemies should change direction
func should_change_direction() -> bool:
	for enemy in get_children():
		if enemy is Enemy:
			if enemy.position.x <= left_boundary or enemy.position.x >= right_boundary:
				return true
	return false

# Function to spawn enemies based on the given configuration
func spawn_enemies(enemy_data):
	var spacing = Vector2(35, 25)  # Space between enemies

	for config in enemy_data:
		var enemy_type = config["type"]
		var rows = config["rows"]
		var cols = config["cols"]

		# Spawn each enemy in the grid
		for row in range(rows):
			for col in range(cols):
				AudioManager.play_sound(AudioManager.BEEP)
				spawn_delay.start()
				await spawn_delay.timeout
				
				# Calculate position for the enemy
				var position = config.start_pos + Vector2(col * spacing.x, row * spacing.y)
				
				# Spawn and instance the enemy
				var enemy_instance = enemy_type.instantiate()
				enemy_instance.position = position
				enemy_instance.enemyType = config.id
				add_child(enemy_instance)
	ships_in_place.emit()
	movement_timer.start()

func _on_level_stop_game() -> void:
	game_stopped = true

func _on_level_start_game() -> void:
	game_stopped = false

func update_current_sound() -> void:
	current_sound += 1
	if current_sound > 3:
		current_sound = 0
