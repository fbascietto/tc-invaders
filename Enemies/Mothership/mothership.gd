extends CharacterBody2D
class_name Mothership

@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var death_timer: Timer = $DeathTimer
const ENEMY_EXPLOSION = preload("res://Assets/Sprites/Invaders/space__0009_EnemyExplosion.png")

var SPEED := 1.3
var dead := false
var right_boundary : int

func _ready() -> void:
	right_boundary = get_viewport().size.x + 25

func _physics_process(delta: float) -> void:
	if(!dead):
		move()
		checkEnd()

func move() -> void:
	position += SPEED * Vector2(1, 0)

func checkEnd():
	if position.x >= right_boundary:
		queue_free()

func die() -> void:
	dead = true
	Global.update_score(150)
	sprite_2d.texture = ENEMY_EXPLOSION
	sprite_2d.scale *= 1.5
	# AudioManager.play_sound(AudioManager.DEATH)
	death_timer.start()
	await death_timer.timeout
	queue_free()

func getIsDead() -> bool:
	return dead
