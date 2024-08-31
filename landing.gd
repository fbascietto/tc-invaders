extends Control

const MAIN_LEVEL = preload("res://Levels/Level.tscn")
@onready var menu_music_player = $AudioStreamPlayer

func _on_check_button_toggled(toggled_on: bool) -> void:
	Global.cuadrazo_edition = toggled_on
	grab_focus()

func _on_button_pressed() -> void:
	get_tree().change_scene_to_packed(MAIN_LEVEL)
