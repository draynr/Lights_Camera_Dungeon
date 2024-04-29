extends Node

var enemy_scene = preload ("../jason_test/enemy_0.tscn")
var teapot_scene = preload ("../jason_test/teapot.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func spawn_enemy():

	# if (randf() >= .5):
	# 	var teapot = teapot_scene.instantiate()
	# 	add_child(teapot)
	# 	teapot.global_position.y = 0.2
	# else:
	# 	var enemy = enemy_scene.instantiate()
	# 	add_child(enemy)
	# 	enemy.global_position.y = 0.2
	pass

func _on_enemy_timer_timeout():
	# pass # Replace with function body.
	spawn_enemy()
