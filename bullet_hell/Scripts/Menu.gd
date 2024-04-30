extends Control

@onready var music = $Music
@onready var killed_player = $Killed_Player
func _process(delta):
	if !music.playing:
		music.play()
func _on_play_pressed():
	get_tree().change_scene_to_file("res://Scene/Main.tscn")

func _on_quit_pressed():
	get_tree().quit()
