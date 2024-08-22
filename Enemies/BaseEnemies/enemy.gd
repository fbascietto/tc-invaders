extends CharacterBody2D
class_name Enemy

@export var laser_particle_scene: PackedScene

@onready var death_timer: Timer = $DeathTimer
@onready var shoot_delay: Timer = $ShootDelay
@onready var enemyType: int = name.substr(5,1).to_int()

var chance: float
var are3LasersPresent: bool = false
var isDead: bool = false

func _ready() -> void:
	$AnimatedSprite2D.play("Move")
	
func _physics_process(delta: float) -> void:
	are3LasersPresent = getLevel().get_children().filter(getLasers).size() > 2;
	var rng := RandomNumberGenerator.new()
	chance = rng.randf_range(0, 1.0)
	shouldShootLasers()
	
func shouldShootLasers() -> void:
	if(chance < 0.00012 && !are3LasersPresent):
		shoot_laser()

func move(distance: float, direction: Vector2) -> void:
	position += distance * direction

func move_down(distance: float) -> void:
	position.y += distance

func die() -> void:
	isDead = true
	Global.update_score(10 * enemyType)
	$AnimatedSprite2D.play("Death")
	death_timer.start()
	await death_timer.timeout
	queue_free()

func shoot_laser() -> void:
	var projectile = laser_particle_scene.instantiate()
	projectile.position = position
	getLevel().add_child(projectile)
	# AudioManager.play_sound(AudioManager.LASER)

func getLevel() -> Node:
	return get_parent().get_parent()
	
func getLasers(c: Node) -> bool: 
	return c is Laser
	
func getIsDead() -> bool:
	return isDead
