extends "res://singletons/run_data.gd"

# Added set bonus for One-armed
func update_sets()->void :
	
	for effect in active_set_effects:
		effect[1].unapply()
	
	active_set_effects = []
	active_sets = {}
	
	for weapon in weapons:
		for set in weapon.sets:
			if active_sets.has(set.my_id):
				active_sets[set.my_id] += 1
			else :
				active_sets[set.my_id] = 1
				### Treats One-armed as having a 4-set Bonus, except for Legendary weapons
				if RunData.current_character.name == "CHARACTER_ONE_ARM" and not set.my_id == "set_legendary":
					active_sets[set.my_id] = 4	
				###
	
	for key in active_sets:
		if active_sets[key] >= 2:
			var set = ItemService.get_set(key)
			var set_effects = set.set_bonuses[min(active_sets[key] - 2, set.set_bonuses.size() - 1)]
			
			for effect in set_effects:
				effect.apply()
				active_set_effects.push_back([key, effect])
