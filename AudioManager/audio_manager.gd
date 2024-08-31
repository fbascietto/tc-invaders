extends Node

#Music

#Sounds
const EXPLOSION = preload("res://Assets/Audio/explosion.wav")
const FASTINVADER_1 = preload("res://Assets/Audio/fastinvader1.wav")
const FASTINVADER_2 = preload("res://Assets/Audio/fastinvader2.wav")
const FASTINVADER_3 = preload("res://Assets/Audio/fastinvader3.wav")
const FASTINVADER_4 = preload("res://Assets/Audio/fastinvader4.wav")
const INVADERKILLED = preload("res://Assets/Audio/invaderkilled.wav")
const SHOOT = preload("res://Assets/Audio/shoot.wav")
const UFO_HIGHPITCH = preload("res://Assets/Audio/ufo_highpitch.wav")
const UFO_LOWPITCH = preload("res://Assets/Audio/ufo_lowpitch.wav")
const ENEMY_SHOT = preload("res://Assets/Audio/enemy_shot.wav")
const BEEP = preload("res://Assets/Audio/beep.mp3")

#Refrences
@onready var music_players = $Music.get_children()
@onready var sound_players = $Sounds.get_children()

func play_sound(sound):
	for player in sound_players:
		if not player.playing:
			player.stream = sound
			player.play()
			break

func play_music(sound):
	for player in music_players:
		if not player.playing:
			player.stream = sound
			player.play()
			break
