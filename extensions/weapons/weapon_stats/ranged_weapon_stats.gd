#!# CURRENTLY UNUSED CHANGES

extends "res://weapons/weapon_stats/ranged_weapon_stats.gd"

# Replace to add a context-appropriate extra decimal to cooldown and to bugfix the Big Reload cooldown tooltip
func get_cooldown_text(base_stats:Resource, multiplier:float = 1.0)->String:
	print("this part does not get run?")
	var cd = get_cooldown_value(base_stats)
	var base_cd = get_base_cooldown_value(base_stats)
	var a = get_col_a( - cd, - base_cd)
	
	###
	# Doing this directly because get_cooldown_value just uses base cooldown even if you try to feed it something else
	var reload_cd = base_stats.recoil_duration * 2 + ((cooldown * multiplier) / 60.0)
	# Cooldown every X shots weapon e.g. Revolver
	if multiplier > 1:
		cd = reload_cd
	
	# For small cooldowns, show an extra decimal
	if cd <= 0.2:
		return a + str(stepify(cd, 0.001)) + "s" + col_b
	else:
	###	
		return a + str(stepify(cd, 0.01)) + "s" + col_b
		#return a + str(stepify(cd * multiplier, 0.01)) + "s" + col_b
