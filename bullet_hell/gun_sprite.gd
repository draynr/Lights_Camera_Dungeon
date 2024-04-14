extends Sprite3D



func _process(_delta: float) -> void:
	var rot := rotation.z
	# Get camera coordinates
	var cam = get_viewport().get_camera_3d()
	var look_pos : Vector3 = cam.global_position
	look_pos.y = global_position.y
	
	# First look directly at the camera, then rotate around own axis
	# Note: as an up axis here is camera's up, but one might want to use Vector3.UP instead
	look_at(look_pos, cam.global_transform.basis.y)
	rotation.z = rot
