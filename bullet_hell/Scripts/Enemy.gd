extends CharacterBody3D
var speed = 2
var player_chase = false
var player = null


func _physics_process(delta):
	if player_chase:
		position += (player.position-position)/speed
		
func _on_Area3D_body_entered(body):
	player = body
	player_chase = true
	
func _on_Area3D_body_exit(body):
	player = null
	player_chase = false

		
