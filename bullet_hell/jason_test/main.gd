extends Node

var enemy_scene = preload ("res://jason_test/enemy_0.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func spawn_enemy():
	var enemy = enemy_scene.instantiate()
	add_child(enemy)

func _on_enemy_spawn_timer_timeout():
	# pass # Replace with function body.
	spawn_enemy()
