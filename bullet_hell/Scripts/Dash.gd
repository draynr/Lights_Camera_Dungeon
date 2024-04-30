extends Node3D

@onready var duration_timer = $DurationTimer
const dash_cooldown = 1.5
var can_dash = true
var sprite

func start_dash(sprite, duration):
	self.sprite = sprite
	duration_timer.wait_time = duration
	duration_timer.start()
	
func is_dashing():
	return !duration_timer.is_stopped()

func end_dash():
	can_dash = false
	await get_tree().create_timer(dash_cooldown).timeout
	can_dash = true

func _on_duration_timer_timeout():
	end_dash()
