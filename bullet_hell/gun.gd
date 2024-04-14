extends Node3D

var radius = 0.5
func aim_gun(player, target_pos, gun):
	var adjusted_pos = Vector3(target_pos.z, 0, -target_pos.x)
	var up = Vector3(0, 1, 0)
	gun.global_transform.origin = player.global_transform.origin  # Ensure the gun starts at the player's position
	var look_target = player.global_transform.origin + adjusted_pos
	gun.look_at(player.global_transform.origin + adjusted_pos, up)
