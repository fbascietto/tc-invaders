extends Node
class_name Shelter

var health := 3
var sprites = ["dmg3", "dmg2", "dmg1"]

func take_damage() -> void:
	health -= 1
	if health < 0:
		die()
	$AnimatedSprite2D.play(sprites[health])
	
func die():
	queue_free()
