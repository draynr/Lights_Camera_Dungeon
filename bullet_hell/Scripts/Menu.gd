extends Control

@onready var music1 = $Music1
@onready var music2 = $Music2
@onready var music3 = $Music3
@onready var music4 = $Music4
@onready var music5 = $Music5
@onready var music6 = $Music6
@onready var music7 = $Music7
@onready var music8 = $Music8
@onready var music9 = $Music9

var last_music = null
var rng = RandomNumberGenerator.new()
var my_random_number
var last_num 
@onready var killed_player = get_node("player/Killed_Player")

func _process(delta):
	if last_music == null || !last_music.playing:
		while last_num == my_random_number:
			last_num = randi_range(0, 9)
		my_random_number = last_num
		match my_random_number:
			1:
				last_music = music1
				last_music.play()
			2:
				last_music = music2
				last_music.play()
			3:
				last_music = music3
				last_music.play()
			4:
				last_music = music4
				last_music.play()
			5:
				last_music = music5
				last_music.play()
			6:
				last_music = music6
				last_music.play()
			7:
				last_music = music7
				last_music.play()
		
func _on_play_pressed():
	get_tree().change_scene_to_file("res://Scene/Main.tscn")

func _on_quit_pressed():
	get_tree().quit()
