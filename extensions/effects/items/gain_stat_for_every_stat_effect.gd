extends "res://effects/items/gain_stat_for_every_stat_effect.gd"

# Replace, Tooltip cleanup
func get_args()->Array:
	var actual_nb_scaled = 0
	var key_arg = key
	var perm_only = text_key.to_upper() == "EFFECT_GAIN_STAT_FOR_EVERY_PERM_STAT"
	
	if stat_scaled == "materials":
		actual_nb_scaled = RunData.gold
	elif stat_scaled == "structure":
		actual_nb_scaled = RunData.effects["structures"].size()
		###
		if RunData.effects["tree_turrets"] > 0:
			actual_nb_scaled += 1
		###
	elif stat_scaled == "living_enemy":
		actual_nb_scaled = RunData.current_living_enemies
	elif stat_scaled == "common_item":
		actual_nb_scaled = RunData.get_nb_different_items_of_tier(Tier.COMMON)
	elif stat_scaled == "legendary_item":
		actual_nb_scaled = RunData.get_nb_different_items_of_tier(Tier.LEGENDARY)
	elif stat_scaled.begins_with("item_"):
		actual_nb_scaled = RunData.get_nb_item(stat_scaled, false)
	elif stat_scaled == "living_tree":
		actual_nb_scaled = RunData.current_living_trees
	elif perm_only:
		actual_nb_scaled = RunData.get_stat(stat_scaled)
	else :
		actual_nb_scaled = RunData.get_stat(stat_scaled) + TempStats.get_stat(stat_scaled)
	
	### Flip to ceiling rounding for negative values
	#var bonus = floor(value * (actual_nb_scaled / nb_stat_scaled))
	var bonus = value * (actual_nb_scaled / nb_stat_scaled)
	if bonus >= 0:
		bonus = floor(bonus)
	else: 
		bonus = ceil(bonus)
	
	# Text cleanup
	if bonus == -0:
		bonus = 0
	###
	
	if key_arg == "number_of_enemies":
		key_arg = "pct_number_of_enemies"
	
	return [str(value), tr(key_arg.to_upper()), str(nb_stat_scaled), tr(stat_scaled.to_upper()), str(bonus)]
