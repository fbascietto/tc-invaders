extends CharacterBody2D
class_name Enemy

@export var laser_particle_scene: PackedScene

@onready var death_timer: Timer = $DeathTimer

var enemyType: int
var chance: float
var started: bool = false
var are3LasersPresent: bool = false
var isDead: bool = false
	
func _physics_process(_delta: float) -> void:
	are3LasersPresent = getLevel().get_children().filter(getLasers).size() > 2;
	var rng := RandomNumberGenerator.new()
	chance = rng.randf_range(0, 1.0)
	shouldShootLasers()
	
func shouldShootLasers() -> void:
	if(chance < Global.enemy_ammo && !are3LasersPresent && started):
		shoot_laser()

func move(distance: float, direction: Vector2) -> void:
	position += distance * direction

func move_down(distance: float) -> void:
	position.y += distance

func die() -> void:
	isDead = true
	Global.update_score(10 * enemyType)
	$AnimatedSprite2D.play("Death")
	AudioManager.play_sound(AudioManager.INVADERKILLED)
	death_timer.start()
	await death_timer.timeout
	queue_free()

func shoot_laser() -> void:
	var projectile = laser_particle_scene.instantiate()
	projectile.position = position
	getLevel().add_child(projectile)
	AudioManager.play_sound(AudioManager.ENEMY_SHOT)

func getLevel() -> Node:
	return get_parent().get_parent()
	
func getLasers(c: Node) -> bool: 
	return c is Laser
	
func getIsDead() -> bool:
	return isDead

func start_ship() -> void:
	started = true
	$AnimatedSprite2D.play("Move")
