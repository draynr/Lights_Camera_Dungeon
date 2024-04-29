extends CharacterBody3D

var dir: float
var spawnCoords: Vector3
var spawnRotation: Vector3
var speed = 1.8
var lifetime = 5.
var projectile_texture

var velocitydir: Vector3
var acceldir: Vector3

#@onready var sprite: Sprite3D = get_node("Sprite3D")
#@onready var sphereshape: SphereShape3D = get_node("Area3D/CollisionShape3D").shape

@onready var player = get_parent().get_node("player") #preload ("res://jason_test/player.gd")

func _ready():
	global_position = spawnCoords
	velocitydir = spawnRotation
	$LifetimeTimer.wait_time = lifetime
	$LifetimeTimer.start()
	$Sprite3D.texture = projectile_texture

func scale_bullet(scal):
	var sph = get_node("Area3D/CollisionShape3D").shape
	$Sprite3D.scale *= scal
	sph.radius *= scal

func _physics_process(delta):
	velocity = velocitydir * speed
	move_and_slide()
	velocitydir = velocitydir + acceldir*delta
	
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
