extends "res://entities/units/player/player.gd"

# Replace; fixes instant-Revolver-reloaded bug
func reset_weapons_cd()->void :
	for weapon in current_weapons:
		if is_instance_valid(weapon):
			###
			var has_big_reload = weapon.current_stats.additional_cooldown_every_x_shots != - 1
			if not has_big_reload:
			###
				weapon._current_cooldown = min(weapon._current_cooldown, weapon.current_stats.cooldown)
			