extends Node2D

@onready var mothership_point: Marker2D = $MothershipPoint
@onready var lives: Array[Node] = $Control/LiveDisplay.get_children()

const MOTHERSHIP = preload("res://Enemies/Mothership/Mothership.tscn")

var chance: float
var isMothershipPresent: bool = false

func _ready() -> void:
	# Generate HiveMind
	
	# Freeze the game
	freeze_start()

func _physics_process(delta: float) -> void:
	$Control/Score.text = "Score:  " + str(Global.score)
	isMothershipPresent = get_children().map(getMotherships).any(isTrue);
	var rng := RandomNumberGenerator.new()
	chance = rng.randf_range(0, 1.0)
	shouldSpawnMothership()
	
func shouldSpawnMothership() -> void:
	if(chance < 0.005 && !isMothershipPresent):
		spawnMothership()

func spawnMothership() -> void:
	var mothership = MOTHERSHIP.instantiate()
	mothership.position = mothership_point.position
	add_child(mothership)

func getMotherships(c: Node) -> bool: 
	return c is Mothership

func isTrue(b: bool) -> bool:
	return b

func _on_player_player_death() -> void:
	if Global.lives >= 0:
		Global.lives -= 1
		lives[Global.lives].visible = false
		freeze_start()
		$Player.respawn($PlayerSpawn)
	else:
		#endgame
		pass

func freeze_start() -> void:
	# Freeze the game
	$Control/GetReady.visible = true
	$StartTimer.start()
	get_tree().paused = true
	await $StartTimer.timeout
	get_tree().paused = false
	$Control/GetReady.visible = false
