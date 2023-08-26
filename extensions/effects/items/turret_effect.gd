extends "res://effects/items/turret_effect.gd"

# Replace function to show a decimal for Garden cooldown with Improved Tools
func get_args()->Array:
	if is_burning:
		
		var burning_ticks = effects[0].burning_data.duration
		
		var scaling_stats_value = WeaponService.get_scaling_stats_value(stats.scaling_stats)
		var scaling_stats_names = WeaponService.get_scaling_stats_icons(stats.scaling_stats)
		
		var burning_dmg = max(1.0, round(effects[0].burning_data.damage + scaling_stats_value))
		
		return [str(burning_dmg), str(burning_ticks), scaling_stats_names]
	elif is_spawning:
		
		var spawn_cd = stats.cooldown
		
		if RunData.effects["structures_cooldown_reduction"].size() > 0:
			spawn_cd = Utils.apply_cooldown_reduction(spawn_cd, RunData.effects["structures_cooldown_reduction"])
		
		###return [str(int(spawn_cd / 60.0))]
		return [str(stepify((spawn_cd / 60.0), 0.1))]
		###
	else :
		var scaling_stats_names = WeaponService.get_scaling_stats_icons(stats.scaling_stats)
		var init_stats = WeaponService.init_ranged_stats(stats, "", [], effects, true)
		
		return [str(init_stats.damage), scaling_stats_names, str(init_stats.nb_projectiles), str(init_stats.bounce)]
