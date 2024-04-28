extends Node

var enemy_scene = preload ("../jason_test/enemy_0.tscn")
var teapot_scene = preload ("../jason_test/teapot.tscn")
var player = preload ("../jason_test/player.gd")

var main_entered = false
var room_1_entered = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
	# spawn_enemy(teapot_scene, $Rooms/MainRoom/MainRoomTopRight)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

# func spawn_enemy():

func _on_room_1_body_entered(body):
	# pass # Replace with function body.
	# player.current_room = $Rooms/Room_1
	if (!room_1_entered):
		spawn_enemy(teapot_scene, $Rooms/room1_br)
		spawn_enemy(teapot_scene, $Rooms/room1_bl)
		$room_1_spawner.start()
		# spawn_enemy(teapot_scene, $Rooms/room1_tr)
		# spawn_enemy(teapot_scene, $Rooms/room1_tl)
		room_1_entered = true

func _on_main_room_body_entered(body):

	# pass # Replace with function body.
	# player.current_room = $MainRoom
	# print(player.global_position)
	if (!main_entered):
		spawn_enemy(enemy_scene, $Rooms/main_tr)
		spawn_enemy(enemy_scene, $Rooms/main_tl)
		main_entered = true

func spawn_enemy(spawn_type, marker):
	var enemy = spawn_type.instantiate()
	enemy.global_position = marker.position;

	# print(enemy)
	print(marker.position)
	add_child(enemy)

func _on_room_1_spawner_timeout():
	spawn_enemy(teapot_scene, $Rooms/room1_tr)
	spawn_enemy(teapot_scene, $Rooms/room1_tl)
	spawn_enemy(enemy_scene, $Rooms/room1_br)
	spawn_enemy(enemy_scene, $Rooms/room1_bl)
