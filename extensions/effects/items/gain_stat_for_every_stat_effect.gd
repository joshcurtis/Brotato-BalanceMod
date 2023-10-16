extends "res://effects/items/gain_stat_for_every_stat_effect.gd"

# Replace, Tooltip cleanup
# Add Pocket Factory to Streamer's structure bonus
# King's changed ability
#
func get_args()->Array:
	var actual_nb_scaled = 0
	var key_arg = key
	var perm_only = text_key.to_upper() == "EFFECT_GAIN_STAT_FOR_EVERY_PERM_STAT"
	
	if stat_scaled == "materials":
		actual_nb_scaled = RunData.gold
	elif stat_scaled == "structure":
		actual_nb_scaled = RunData.effects["structures"].size()
		### Count Pocket Factory once for Streamer Armor bonus
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
	### Stat for materials leftover at end of wave (New Padding)
	elif stat_scaled == "bm_leftover_materials":
		actual_nb_scaled = RunData.effects["bm_leftover_materials"]
	##
	### New King ability counts uniques rather than total tier-4 weapons
	elif stat_scaled == "bm_unique_legendary_weapon":
		var unique_tier4_weapon_ids = []
		for weapon in RunData.weapons:
			if weapon.tier >= Tier.LEGENDARY: 
				if not unique_tier4_weapon_ids.has(weapon.weapon_id):
					unique_tier4_weapon_ids.push_back(weapon.weapon_id)
		actual_nb_scaled = unique_tier4_weapon_ids.size()
	##
	elif perm_only:
		actual_nb_scaled = RunData.get_stat(stat_scaled)
	else :
		### [Currently off because the actual stat change wasn't working] Adding LinkedStats as well, e.g. Fairy, Chunky Passive, etc.
		actual_nb_scaled = RunData.get_stat(stat_scaled) + TempStats.get_stat(stat_scaled)
		##actual_nb_scaled = RunData.get_stat(stat_scaled) + TempStats.get_stat(stat_scaled) + LinkedStats.get_stat(stat_scaled)
		###
	
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
