extends RayCast3D

var target = null

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	# pass
	if is_colliding():
		if get_collider().is_in_group("player"):
			target = get_collider()
