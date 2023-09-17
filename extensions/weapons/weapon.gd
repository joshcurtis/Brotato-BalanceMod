#!# CURRENTLY UNUSED CHANGES
extends "res://weapons/weapon.gd"

# Replace
func shoot()->void :
	_nb_shots_taken += 1
	update_current_spread()
	_hitbox.set_knockback( - Vector2(cos(rotation), sin(rotation)), current_stats.knockback)
	
	if ProgressData.is_manual_aim():
		_shooting_behavior.shoot(current_stats.max_range)
	else :
		_shooting_behavior.shoot(_current_target[1])
	
	var is_big_reload = current_stats.additional_cooldown_every_x_shots != - 1 and _nb_shots_taken % current_stats.additional_cooldown_every_x_shots == 0
	
	if is_big_reload:
		_current_cooldown = current_stats.cooldown * current_stats.additional_cooldown_multiplier
	else :
		#var max_rand = min(_parent.get_nb_weapons() * current_stats.cooldown / 5.0, _parent.get_nb_weapons() * 5)
		### Cap counted weapons at 6 to remove Multi-tasker silliness, halved impact of each weapon
		var weapon_count = min(_parent.get_nb_weapons(), 6)
		var max_rand = min(weapon_count * current_stats.cooldown / 10.0, weapon_count * 2.5)
		print("max ", max_rand)
		###
		_current_cooldown = rand_range(max(1, current_stats.cooldown - max_rand), current_stats.cooldown + max_rand)
		print("new ", _current_cooldown)
	
	if ((current_stats.additional_cooldown_every_x_shots != - 1 and is_big_reload) or current_stats.additional_cooldown_every_x_shots == - 1) and stats.custom_on_cooldown_sprite != null:
		sprite.texture = stats.custom_on_cooldown_sprite