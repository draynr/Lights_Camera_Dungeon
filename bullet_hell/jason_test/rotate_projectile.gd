extends CharacterBody3D

var dir: float
var spawnCoords: Vector3
var spawnRotation: Vector3
var speed = 1.2
var lifetime = 5.
var projectile_texture
var orbit_radius = 2.

@onready var player = get_parent().get_node("player")

func _ready():
	global_position = spawnCoords
	global_rotation = spawnRotation
	$LifetimeTimer.wait_time = lifetime
	$LifetimeTimer.start()
	$Sprite3D.texture = projectile_texture

func scale_bullet(scal):
	var sph = get_node("Area3D/CollisionShape3D").shape
	$Sprite3D.scale *= scal
	sph.radius *= scal

func _process(delta):
	move_and_slide()

func _on_area_3d_body_entered(body):
	if body.is_in_group("player"):
		var player = body
		# player.take_damage(1)
		# queue_free()
	elif body.is_in_group("map"):
		queue_free()

func _on_area_3d_area_entered(area):
	if area.is_in_group("playerhurtbox"):
		player.take_damage(1)
		queue_free()

func _on_lifetime_timer_timeout_new():
	queue_free()