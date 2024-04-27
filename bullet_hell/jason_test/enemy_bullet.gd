extends CharacterBody3D

var dir: float
var spawnCoords: Vector3
var spawnRotation: Vector3
var speed = 1.8
var lifetime = 5.
var projectile_texture

# var Player = preload ("res://jason_test/player.gd")

func _ready():
	# pass # Replace with function body.
	global_position = spawnCoords
	global_rotation = spawnRotation
	$LifetimeTimer.wait_time = lifetime
	$LifetimeTimer.start()
	$Sprite3D.texture = projectile_texture

func _process(delta):
	# this code follows player, maybe something we want later
	# var player = get_parent().get_node("player")
	# if player:
	# 	var direction = (player.global_position - global_position).normalized()
	# 	rotation.y = atan2(direction.x, direction.z)
	# 	velocity = direction * speed
	velocity = global_rotation * speed
	move_and_slide()
	
func _on_area_3d_body_entered(body):
	if body.is_in_group("player"):
		var player = body
		player.take_damage(1)
		queue_free()
	elif body.is_in_group("map"):
		queue_free()
func _on_lifetime_timer_timeout_new():
	queue_free()
