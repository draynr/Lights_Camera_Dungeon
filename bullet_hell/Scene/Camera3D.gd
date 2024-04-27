extends Camera3D

#@onready var svpc: SubViewportContainer = get_node("Main/player/SubViewportContainer")

# Called when the node enters the scene tree for the first time.
func _ready():
	# var shader_material = ShaderMaterial.new()
	# shader_material.shader = load("res://jason_test/Cam.gdshader")
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	# global_position = get_parent().get_parent().get_parent().global_position
	pass

func camera_shake(period, magnitude):
	randomize()
	var initial_transform = self.transform

	var elapsed_time = 0.0
	while elapsed_time < period:
		var offset = Vector3(
			randf_range( - magnitude, magnitude),
			randf_range( - magnitude, magnitude),
			0.0
		)
		self.transform.origin = initial_transform.origin + offset
		elapsed_time += get_process_delta_time()
		await get_tree().process_frame

	self.transform = initial_transform
