extends "res://effects/weapons/projectiles_on_hit_effect.gd"

# Replace, fixes Shiv bounce count
func get_args()->Array:
	var current_stats = WeaponService.init_ranged_stats(weapon_stats)
	var scaling_text = WeaponService.get_scaling_stats_icons(weapon_stats.scaling_stats)
	### Remove the incorrect + 1
	return [str(value), str(current_stats.damage), str(current_stats.bounce), scaling_text]
	#return [str(value), str(current_stats.damage), str(current_stats.bounce + 1), scaling_text]