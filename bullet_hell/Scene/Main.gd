extends Node

var enemy_scene = preload ("../jason_test/enemy_0.tscn")
var teapot_scene = preload ("../jason_test/teapot.tscn")
var camera_scene = preload ("../jason_test/camera.tscn")
var player = preload ("../jason_test/player.gd")

var main_entered = false
var room_1_entered = false
var room_2_entered = false

var enemies_alive = 0
@onready var cnt = 0

@onready var room1_br = $Rooms/room1_br
@onready var room1_bl = $Rooms/room1_bl
@onready var room1_tr = $Rooms/room1_tr
@onready var room1_tl = $Rooms/room1_tl
@onready var room1_spawner = $room_1_spawner

@onready var room2_br = $Rooms/room2_br
@onready var room2_bl = $Rooms/room2_bl
@onready var room2_tr = $Rooms/room2_tr
@onready var room2_tl = $Rooms/room2_tl
@onready var room2_spawner = $room_2_spawner

@onready var main_tr = $Rooms/main_tr
@onready var main_tl = $Rooms/main_tl

@onready var doors = $doors


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
	# spawn_enemy(teapot_scene, $Rooms/MainRoom/MainRoomTopRight)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_room_2_body_entered(body):
	# pass # Replace with function body.
	# player.current_room = $Rooms/Room_1
	if (!room_2_entered):
		add_child(doors)
		spawn_enemy(camera_scene, room2_br)
		spawn_enemy(camera_scene, room2_bl)
		room2_spawner.start()
		room_2_entered = true

func _on_room_1_body_entered(body):
	# pass # Replace with function body.
	# player.current_room = $Rooms/Room_1
	if (!room_1_entered):
		add_child(doors)
		spawn_enemy(teapot_scene, room1_br)
		spawn_enemy(teapot_scene, room1_bl)
		room1_spawner.start()
		room_1_entered = true

func _on_main_room_body_entered(body):

	# pass # Replace with function body.
	# player.current_room = $MainRoom
	# print(player.global_position)
	if (!main_entered):
		add_child(doors)
		spawn_enemy(enemy_scene, main_tr)
		spawn_enemy(enemy_scene, main_tl)
		main_entered = true

func spawn_enemy(spawn_type, marker):
	var enemy = spawn_type.instantiate()
	enemy.global_position = marker.position;
	enemies_alive += 1
	enemy.died.connect(enemy_killed)

	# print(enemy)
	#print(marker.position)
	add_child(enemy)

func _on_room_1_spawner_timeout():
	spawn_enemy(teapot_scene, room1_tr)
	spawn_enemy(teapot_scene, room1_tl)
	spawn_enemy(enemy_scene, room1_br)
	spawn_enemy(enemy_scene, room1_bl)

func _on_room_2_spawner_timeout():

	spawn_enemy(camera_scene, room2_tr)
	spawn_enemy(camera_scene, room2_tl)
	spawn_enemy(camera_scene, room2_br)
	spawn_enemy(camera_scene, room2_bl)
	if cnt < 2:
		room2_spawner.start()
		cnt += 1
		
func enemy_killed():
	if (enemies_alive <= 0):
		pass
	enemies_alive -= 1
	if enemies_alive <= 0:
		enemies_alive = 0
		remove_child(doors)
