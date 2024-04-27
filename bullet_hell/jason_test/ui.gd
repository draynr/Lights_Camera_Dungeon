extends CanvasLayer

var hearts = 5
var maxhearts = 5
@onready var player = get_parent().get_node("player")
@onready var healthEmpty = $HealthEmpty
@onready var healthFull = $HealthFull

func _ready():
	# pass # Replace with function body.
	if player != null:
		player.health_changed.connect(change_texture)

func change_texture(value):
	hearts = value
	if hearts >= 0:
		if hearts <= maxhearts:
			healthFull.size.x = hearts * 18
