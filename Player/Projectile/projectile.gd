extends Area2D

@export var speed: float = 400.0
var iName = 'projectile'

func _ready():
	connect("body_entered", Callable(self, "_on_body_entered"))

func _physics_process(delta) -> void:
	position.y -= speed * delta
	if position.y < 0:
		queue_free()

func _on_body_entered(body) -> void:
	if body is Enemy or body is Mothership:
		if !body.getIsDead():
			body.die()
			queue_free()

func _on_area_entered(area) -> void:
	if area is Shelter:
		area.take_damage()
		queue_free()
