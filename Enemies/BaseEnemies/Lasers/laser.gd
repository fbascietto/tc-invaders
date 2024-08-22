extends Area2D
class_name Laser
@export var speed: float = 200.0

func _ready():
	$AnimatedSprite2D.play('shoot')
	connect("body_entered", Callable(self, "_on_body_entered"))

func _physics_process(delta) -> void:
	position.y += speed * delta
	if position.y > 640:
		queue_free()

func _on_body_entered(body) -> void:
	if body is Player:
		body.die()
		queue_free()

func _on_area_entered(area) -> void:
	if area is Shelter:
		area.take_damage()
		queue_free()
