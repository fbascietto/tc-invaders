extends Node

@onready var movement_timer: Timer = $MovementTimer

# Boundary variables
var right_boundary: int
var left_boundary: int = 25

# Define movement step and direction
var move_distance := 10.0
var move_direction := Vector2(1, 0) # Moving right initially

# Direction changed flag
var changed: bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	right_boundary = get_viewport().size.x - 25
	movement_timer.start()

# Move enemies down after they hit the boundary and reverse direction
func move_enemies_down():
	for enemy in get_children():
		if enemy is Enemy:
			enemy.move_down(move_distance)

func move_enemies():
	# Move enemies by a fixed amount each time the timer fires
	for enemy in get_children():
		if enemy is Enemy:
			enemy.move(move_distance, move_direction)

func _on_movement_timer_timeout() -> void:
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
