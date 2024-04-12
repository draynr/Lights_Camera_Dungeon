extends Node3D

var hit_something: bool = false
var direction: Vector3 = Vector3.ZERO
var proj_speed: int = 0
var damage: int = 1
var hit = -1
@onready var lifetime: Timer = get_node("Lifetime")
@onready var timer: Timer = get_node("HitTime")
@onready var hit_light: OmniLight3D = get_node("HitLight")

func launch(initial_position: Vector3, dir: Vector3, speed: int) -> void:
	position = initial_position
	direction = dir
	#knockback_direction = dir
	proj_speed = speed + 10
	#rotation += dir.angle() + PI/4

func _physics_process(delta: float) -> void:
	if lifetime.is_stopped():
		queue_free()
	elif not hit_something:
		position += direction * proj_speed * delta
	else:
		hit_light.light_energy = timer.time_left * 50
		if timer.is_stopped():
			queue_free()

func _on_body_entered(body):
	if not hit_something and body.is_in_group("enemies"):
		body.take_damage(damage)
		hit_something = true;
		get_node("Sprite3D").visible = false
		get_node("HitSprite").visible = true
		get_parent().get_node("player").get_node("Camera3D").camera_shake(.02, .02)
		hit_light.light_energy = 1.0
		# print(timer)
		timer.start(0.5)
	elif body.is_in_group("map"):
		queue_free()
