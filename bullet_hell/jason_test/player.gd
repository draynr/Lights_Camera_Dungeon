extends CharacterBody3D

# const SPEED = 5.0
# const JUMP_VELOCITY = 4.5
const PROJECTILE_SCENE: PackedScene = preload ("res://jason_test/Projectile.tscn")
@onready var attack_timer: Timer = get_node("AttackTimer")
@onready var iframe_timer: Timer = get_node("Invuln")
@onready var hurtoverlay = get_node("SubViewportContainer/SubViewport/Camera3D/CanvasLayer/ColorRect")
@onready var animatedSprite3d = $AnimatedSprite3D
@onready var hitTimer = $HitTimer
@onready var gun_node = get_node("Gun")
@onready var player_node = get_node(".")

@onready var damaged_audio = $Damaged_Player

@onready var dash_timer = $DashTimer
var current_room = null
signal health_changed(value)

var attack_cd: float = 0.1
var proj_speed: float = 1

var speed = 1.2
var target_velocity = Vector3()

var hp: int = 5
var hearts: float = hp

#stuff for dashing
const dash_speed = 5
const dash_duration = 0.15
@onready var sprite = $AnimatedSprite3D
@onready var dash = $Dash

func _ready():
	current_room = null

func get_input_vector():
	var input_vector = Vector2.ZERO
	input_vector.x = Input.get_action_strength('ui_right') - Input.get_action_strength('ui_left')
	input_vector.y = Input.get_action_strength('ui_down') - Input.get_action_strength('ui_up')
	input_vector = input_vector.normalized()
	return input_vector

func get_click_vector() -> Vector3:
	var viewport = get_node("SubViewportContainer/SubViewport")
	var cam = viewport.get_node("Camera3D")
	var mouse_pos = viewport.get_mouse_position()
	var from = cam.project_ray_origin(mouse_pos)
	var dir = cam.project_ray_normal(mouse_pos) * 1000
	var plane = Plane(Vector3(0, -1, 0), -global_position.y)
	var intersect_pos = plane.intersects_ray(from, dir)
	
	var shoot_vec = intersect_pos - global_position
	var ret_vec = Vector3(shoot_vec.x, 0, shoot_vec.z)
	return ret_vec
	
func get_inputs(dir):
	if Input.is_action_pressed("move_down"):
		dir.z += 1
	if Input.is_action_pressed("move_up"):
		dir.z -= 1
	if Input.is_action_pressed("move_left"):
		dir.x -= 1
	if Input.is_action_pressed("move_right"):
		dir.x += 1
	if Input.is_action_pressed("escape"):
		take_damage(hp)
	if Input.is_action_just_pressed("dash")&&dash.can_dash&&!dash.is_dashing():
		dash.start_dash(sprite, dash_duration)
		$dash_particle.emitting = true
		dash_timer.start()

	if Input.is_action_pressed("debug_tp"):
		print('aaa')
		global_position.x = -5
		global_position.z = -13
		global_position.y = 0.2
	
	dir = dir.normalized()
	return dir

func shoot(shoot_vector: Vector3) -> void:
	var projectile: Area3D = PROJECTILE_SCENE.instantiate()
	get_tree().current_scene.add_child(projectile)
	projectile.launch(global_position, shoot_vector, proj_speed)

func handle_attack():
	var click_vector = get_click_vector()
	var gun = gun_node
	gun.aim_gun(player_node, click_vector, gun_node)
	if Input.is_mouse_button_pressed(1) and attack_timer.is_stopped():
		shoot(click_vector.normalized())
		attack_timer.start(attack_cd)

func _physics_process(delta):
	var dir = Vector3()
	dir = get_inputs(dir)
	# handle_attack()
	var dashing = dash.is_dashing()
	if (!dashing):
		handle_attack()
	target_velocity.x = dir.x * speed if !dashing else dir.x * dash_speed
	target_velocity.z = dir.z * speed if !dashing else dir.z * dash_speed
	velocity = target_velocity
	move_and_slide()
	if (dir == Vector3.ZERO):
		animatedSprite3d.play("idle")
	if not iframe_timer.is_stopped():
		hurtoverlay.visible = true
	else:
		hurtoverlay.visible = false

func flash():
	animatedSprite3d.material_override.set_shader_parameter("active", true)
	hitTimer.start()

func take_damage(dmg):
	if iframe_timer.is_stopped()&&!dash.is_dashing():
		damaged_audio.play()
		var viewport = get_node("SubViewportContainer/SubViewport")
		var colorrect = viewport.get_node("Camera3D/CanvasLayer/ColorRect")
		iframe_timer.start()
		hp -= dmg;
		emit_signal("health_changed", hp)
		if hp <= 0:
			queue_free()
			get_tree().change_scene_to_file("res://Scene/game_over.tscn")
			
func get_hp():
	return hp

func _on_dash_timer_timeout():
	$dash_particle.emitting = false
