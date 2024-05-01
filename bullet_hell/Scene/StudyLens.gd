extends Sprite3D
@onready var main = get_parent()
@onready var player = main.get_node("player")

func _on_area_3d_body_entered(body):
	player.lens_focal_length *= 2
	player.lens_cd *= 0.5
	player.display_text("+Increased Lens Focal Length\n+Decreased Lens Cooldown")
	queue_free()
