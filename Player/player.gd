extends CharacterBody2D
class_name Player

const SPEED = 300.0
@export var laser_particle_scene: PackedScene

@onready var death_timer: Timer = $DeathTimer
@onready var shoot_delay: Timer = $ShootDelay
@onready var sprite_2d: Sprite2D = $Sprite2D

signal player_death
signal game_over

const PLAYER_SHIP = preload("res://Assets/Sprites/Invaders/space__0006_Player.png")
const PLAYER_EXPLOSION = preload("res://Assets/Sprites/Invaders/space__0010_PlayerExplosion.png")

var isEnabled := false

func _physics_process(_delta: float) -> void:
	if !isEnabled:
		return
	
	# Get the input direction and handle the movement/deceleration.
	var direction := Input.get_axis("Left", "Right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	handle_laser_input()
	move_and_slide()

func handle_laser_input() -> void:
	if Input.is_action_pressed("Shoot") and shoot_delay.is_stopped():
		shoot_laser()

func shoot_laser() -> void:
	var projectile = laser_particle_scene.instantiate()
	projectile.position = position
	get_parent().add_child(projectile)
	AudioManager.play_sound(AudioManager.SHOOT)
	shoot_delay.start(0.5)

func _on_shoot_delay_timeout() -> void:
	shoot_delay.stop()

func die() -> void:
	isEnabled = false
	sprite_2d.texture = PLAYER_EXPLOSION
	AudioManager.play_sound(AudioManager.EXPLOSION)
	death_timer.start()
	await death_timer.timeout
	player_death.emit()
	if(Global.lives >= 0):
		self.visible = !visible
	else:
		game_over.emit()
		queue_free()

func respawn(point: Marker2D):
	sprite_2d.texture = PLAYER_SHIP
	position = point.position
	self.visible = !visible
	isEnabled = true

func _on_level_start_game() -> void:
	isEnabled = true

func _on_level_stop_game() -> void:
	isEnabled = false
