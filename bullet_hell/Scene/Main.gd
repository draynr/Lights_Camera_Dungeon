extends Node

var enemy_scene = preload ("../jason_test/enemy_0.tscn")
var teapot_scene = preload ("../jason_test/teapot.tscn")
var camera_scene = preload ("../jason_test/camera.tscn")
# var player = preload ("../jason_test/player.gd")

var main_entered = false
var room_1_entered = false
var room_2_entered = false
var room_3_entered = false
var room_4_entered = false
var room_5_entered = false
var room_6_entered = false
var room_7_entered = false
var room_8_entered = false

@onready var enemies_alive = 0
@onready var cnt = 0

@onready var main_tr = $Rooms/main_tl
@onready var main_tl = $Rooms/main_tr

@onready var room1_br = $Rooms/room_1_br
@onready var room1_bl = $Rooms/room_1_bl
@onready var room1_tr = $Rooms/room_1_tr
@onready var room1_tl = $Rooms/room_1_tl
@onready var room1_spawner = $Rooms/room_1_spawner

@onready var room2_br = $Rooms/room_2_br
@onready var room2_bl = $Rooms/room_2_bl
@onready var room2_tr = $Rooms/room_2_tr
@onready var room2_tl = $Rooms/room_2_tl
@onready var room2_spawner = $Rooms/room_2_spawner

@onready var room3_br = $Rooms/room_3_br
@onready var room3_bl = $Rooms/room_3_bl
@onready var room3_tr = $Rooms/room_3_tr
@onready var room3_tl = $Rooms/room_3_tl
@onready var room3_spawner = $Rooms/room_3_spawner

@onready var room4_br = $Rooms/room_4_br
@onready var room4_bl = $Rooms/room_4_bl
@onready var room4_tr = $Rooms/room_4_tr
@onready var room4_tl = $Rooms/room_4_tl
@onready var room4_spawner = $Rooms/room_4_spawner

@onready var room5_br = $Rooms/room_5_br
@onready var room5_bl = $Rooms/room_5_bl
@onready var room5_tr = $Rooms/room_5_tr
@onready var room5_tl = $Rooms/room_5_tl
@onready var room5_spawner = $Rooms/room_5_spawner

@onready var room6_br = $Rooms/room_6_br
@onready var room6_bl = $Rooms/room_6_bl
@onready var room6_tr = $Rooms/room_6_tr
@onready var room6_tl = $Rooms/room_6_tl
@onready var room6_spawner = $Rooms/room_6_spawner

@onready var room7_br = $Rooms/room_7_br
@onready var room7_bl = $Rooms/room_7_bl
@onready var room7_tr = $Rooms/room_7_tr
@onready var room7_tl = $Rooms/room_7_tl
@onready var room7_spawner = $Rooms/room_7_spawner

@onready var room8_br = $Rooms/room_8_br
@onready var room8_bl = $Rooms/room_8_bl
@onready var room8_tr = $Rooms/room_8_tr
@onready var room8_tl = $Rooms/room_8_tl
@onready var room8_spawner = $Rooms/room_8_spawner

@onready var doors = $doors
@onready var music0 = $Music0
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
var spawning = false
# Called when the node enters the scene tree for the first time.
func _ready():
	remove_child(doors)
	# spawn_enemy(teapot_scene, $Rooms/MainRoom/MainRoomTopRight)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if last_music == null || !last_music.playing:
		while last_num == my_random_number:
			last_num = randi_range(0, 9)
		my_random_number = last_num
		match my_random_number:
			0:
				last_music = music0
				last_music.play()
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
	pass

func _on_main_room_body_entered(body):
	if (!main_entered):
		add_child(doors)
		spawn_enemy(enemy_scene, main_tl)
		spawn_enemy(enemy_scene, main_tr)
		main_entered = true
		
func _on_room_1_body_entered(body):
	if (!room_1_entered):
		add_child(doors)
		spawn_enemy(teapot_scene, room1_br)
		spawn_enemy(teapot_scene, room1_bl)
		room1_spawner.start()
		room_1_entered = true
		spawning = true

func _on_room_2_body_entered(body):
	if (!room_2_entered):
		add_child(doors)
		spawn_enemy(camera_scene, room2_br)
		spawn_enemy(camera_scene, room2_bl)
		room2_spawner.start()
		room_2_entered = true
		spawning = true
		
func _on_room_3_body_entered(body):
	if (!room_3_entered):
		add_child(doors)
		spawn_enemy(camera_scene, room3_br)
		spawn_enemy(camera_scene, room3_bl)
		spawn_enemy(teapot_scene, room3_tr)
		room3_spawner.start()
		room_3_entered = true
		spawning = true

func _on_room_4_body_entered(body):
	if (!room_4_entered):
		add_child(doors)
		spawn_enemy(camera_scene, room4_br)
		spawn_enemy(enemy_scene, room4_bl)
		spawn_enemy(teapot_scene, room4_tr)
		spawn_enemy(camera_scene, room4_tr)
		room4_spawner.start()
		room_4_entered = true
		spawning = true

func _on_room_5_body_entered(body):
	if (!room_5_entered):
		add_child(doors)
		spawn_enemy(enemy_scene, room5_br)
		spawn_enemy(enemy_scene, room5_bl)
		spawn_enemy(teapot_scene, room5_tr)
		room5_spawner.start()
		room_5_entered = true
		spawning = true

func _on_room_6_body_entered(body):
	if (!room_6_entered):
		add_child(doors)
		spawn_enemy(teapot_scene, room6_br)
		spawn_enemy(teapot_scene, room6_bl)
		spawn_enemy(teapot_scene, room6_tr)
		spawn_enemy(teapot_scene, room6_tl)
		room6_spawner.start()
		room_6_entered = true
		spawning = true
		
func _on_room_7_body_entered(body):
	if (!room_7_entered):
		add_child(doors)
		spawn_enemy(teapot_scene, room7_br)
		spawn_enemy(enemy_scene, room7_bl)
		spawn_enemy(camera_scene, room7_tr)
		spawn_enemy(camera_scene, room7_tl)
		room7_spawner.start()
		room_7_entered = true
		spawning = true

func _on_room_8_body_entered(body):
	if (!room_8_entered):
		add_child(doors)
		spawn_enemy(enemy_scene, room8_br)
		spawn_enemy(enemy_scene, room8_bl)
		spawn_enemy(camera_scene, room8_tr)
		spawn_enemy(camera_scene, room8_tl)
		room8_spawner.start()
		room_8_entered = true
		spawning = true
		
func spawn_enemy(spawn_type, marker):
	var enemy = spawn_type.instantiate()
	enemies_alive += 1
	enemy.global_position = marker.global_position;
	add_child(enemy)
	enemy.died.connect(enemy_killed)

func _on_room_1_spawner_timeout():
	spawn_enemy(teapot_scene, room1_tr)
	spawn_enemy(teapot_scene, room1_tl)
	spawn_enemy(enemy_scene, room1_br)
	spawn_enemy(enemy_scene, room1_bl)
	spawning = false

func _on_room_2_spawner_timeout():

	spawn_enemy(camera_scene, room2_tr)
	#spawn_enemy(teapot_scene, room2_tr)
	spawn_enemy(camera_scene, room2_tl)
	if cnt < 1:
		room2_spawner.start()
		cnt += 1
	else:
		spawning = false
		cnt = 0

func _on_room_3_spawner_timeout():

	spawn_enemy(teapot_scene, room3_tr)
	spawn_enemy(enemy_scene, room3_tl)
	spawn_enemy(camera_scene, room3_br)
	if cnt < 1:
		room3_spawner.start()
		cnt += 1
	else:
		spawning = false
		cnt = 0

func _on_room_4_spawner_timeout():
	spawn_enemy(teapot_scene, room4_tr)
	spawn_enemy(camera_scene, room4_tl)
	spawn_enemy(enemy_scene, room4_bl)
	spawn_enemy(teapot_scene, room4_br)
	if cnt < 1:
		room4_spawner.start()
		cnt += 1
	else:
		spawning = false
		cnt = 0

func _on_room_5_spawner_timeout():
	spawn_enemy(enemy_scene, room5_tr)
	spawn_enemy(enemy_scene, room5_tl)
	spawn_enemy(camera_scene, room5_bl)
	spawn_enemy(camera_scene, room5_br)
	if cnt < 2:
		room5_spawner.start()
		cnt += 1
	else:
		spawning = false
		cnt = 0

func _on_room_6_spawner_timeout():
	spawn_enemy(teapot_scene, room6_tr)
	spawn_enemy(enemy_scene, room6_tl)
	spawn_enemy(enemy_scene, room6_bl)
	spawn_enemy(camera_scene, room6_br)
	if cnt < 2:
		room6_spawner.start()
		cnt += 1
	else:
		spawning = false
		cnt = 0

func _on_room_7_spawner_timeout():
	spawn_enemy(teapot_scene, room7_tr)
	spawn_enemy(camera_scene, room7_tl)
	spawn_enemy(enemy_scene, room7_bl)
	spawn_enemy(camera_scene, room7_br)
	if cnt < 2:
		room7_spawner.start()
		cnt += 1
	else:
		spawning = false
		cnt = 0

func _on_room_8_spawner_timeout():
	spawn_enemy(teapot_scene, room8_tr)
	spawn_enemy(teapot_scene, room8_tl)
	spawn_enemy(camera_scene, room8_bl)
	spawn_enemy(enemy_scene, room8_br)
	if cnt < 3:
		room8_spawner.start()
		cnt += 1
	else:
		spawning = false
		cnt = 0
	
func enemy_killed():
	enemies_alive -= 1
	if enemies_alive <= 0 and !spawning:
		enemies_alive = 0
		remove_child(doors)
