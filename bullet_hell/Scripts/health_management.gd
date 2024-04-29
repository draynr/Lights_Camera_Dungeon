extends Node

var max_health: int = 5
var hp: int

func _ready():
	# pass # Replace with function body.
	hp = max_health

func take_dmg(health_amount: int):
	#die
	if hp <= 0:
		queue_free()
	# print('hit')
