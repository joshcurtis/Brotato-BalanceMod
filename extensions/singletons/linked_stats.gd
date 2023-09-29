extends "res://singletons/linked_stats.gd"

# Streamer now gets +2 Armor from Pocket Factory
# New Padding effect	
func reset()->void :
	# From TempStats' reset() which linked_stats extends
	stats = init_stats()
	
	update_on_gold_chance = false
	
	for linked_stat in RunData.effects["stat_links"]:
		var stat_to_tweak = linked_stat[0]
		var stat_scaled = 0
		
		if linked_stat[2] == "materials":
			stat_scaled = RunData.gold
			update_on_gold_chance = true
		elif linked_stat[2] == "structure":
			stat_scaled = RunData.effects["structures"].size()
			### If Pocket Factory, Add 2 more
			if RunData.effects["tree_turrets"] > 0:
				add_stat(stat_to_tweak, 2)
			###
		elif linked_stat[2] == "living_enemy":
			stat_scaled = RunData.current_living_enemies
		elif linked_stat[2] == "living_tree":
			stat_scaled = RunData.current_living_trees
		elif linked_stat[2] == "common_item":
			stat_scaled = RunData.get_nb_different_items_of_tier(Tier.COMMON)
		elif linked_stat[2] == "legendary_item":
			stat_scaled = RunData.get_nb_different_items_of_tier(Tier.LEGENDARY)
		elif linked_stat[2].begins_with("item_"):
			stat_scaled = RunData.get_nb_item(linked_stat[2], false)
		### New Padding effect
		elif linked_stat[2] == "bm_leftover_materials":
			stat_scaled = RunData.effects["bm_leftover_materials"]
		###
		else :
			if RunData.effects.has(linked_stat[2]):
				if linked_stat[4] == true:
					stat_scaled = RunData.get_stat(linked_stat[2])
				else :
					stat_scaled = RunData.get_stat(linked_stat[2]) + TempStats.get_stat(linked_stat[2])
			else :
				continue
		
		var amount_to_add = linked_stat[1] * (stat_scaled / linked_stat[3])
		
		add_stat(stat_to_tweak, amount_to_add)
