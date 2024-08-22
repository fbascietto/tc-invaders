extends CharacterBody2D
class_name Player

const SPEED = 300.0
@export var laser_particle_scene: PackedScene

@onready var death_timer: Timer = $DeathTimer
@onready var shoot_delay: Timer = $ShootDelay
@onready var sprite_2d: Sprite2D = $Sprite2D

signal player_death

const PLAYER_SHIP = preload("res://Assets/Sprites/Invaders/space__0006_Player.png")
const PLAYER_EXPLOSION = preload("res://Assets/Sprites/Invaders/space__0010_PlayerExplosion.png")

func _physics_process(delta: float) -> void:
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
	shoot_delay.start(0.5)
	# AudioManager.play_sound(AudioManager.LASER)

func _on_shoot_delay_timeout() -> void:
	shoot_delay.stop()

func die() -> void:
	sprite_2d.texture = PLAYER_EXPLOSION
	# AudioManager.play_sound(AudioManager.DEATH)
	death_timer.start()
	await death_timer.timeout
	player_death.emit()
	if(Global.lives >= 0):
		self.visible = !visible
	else:
		queue_free()

func respawn(point: Marker2D):
	print('hello')
	sprite_2d.texture = PLAYER_SHIP
	print(sprite_2d.texture.resource_path)
	position = point.position
	self.visible = !visible
