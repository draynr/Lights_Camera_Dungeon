extends Node3D

var enemy_exited: bool = false

var direction: Vector3 = Vector3.ZERO
var proj_speed: int = 0

func launch(initial_position: Vector3, dir: Vector3, speed: int) -> void:
	position = initial_position
	direction = dir
	#knockback_direction = dir
	proj_speed = speed
	
	#rotation += dir.angle() + PI/4


func _physics_process(delta: float) -> void:
	position += direction * proj_speed * delta
