extends "res://singletons/run_data.gd"

# Replaced to guarantee Horde Waves for Loud
func init_elites_spawn(base_wave:int = 10, horde_chance:float = 0.4)->void :
	elites_spawn = []
	var diff = get_current_difficulty()
	var nb_elites = 0
	var possible_elites = ItemService.elites.duplicate()
	
	if current_character != null and current_character.my_id == "character_jack":
		horde_chance = 0.0
	### Loud is guaranteed Horde Waves on 11/12 and 14/15
	elif current_character != null and current_character.my_id == "character_loud":
		horde_chance = 1.0
	###
	
	if diff < 2:
		return 
	elif diff < 4:
		nb_elites = 1
	else :
		nb_elites = 3
	
	var wave = Utils.get_random_int(base_wave + 1, base_wave + 2)
	
	for i in nb_elites:
		
		var type = EliteType.HORDE if randf() < horde_chance else EliteType.ELITE
		
		if DebugService.spawn_specific_elite != "":
			type = EliteType.ELITE
			wave = DebugService.starting_wave
		
		if i == 1:
			wave = Utils.get_random_int(base_wave + 4, base_wave + 5)
		elif i == 2:
			wave = Utils.get_random_int(base_wave + 7, base_wave + 8)
			type = EliteType.ELITE
		
		var elite_id = Utils.get_rand_element(possible_elites).my_id if type == EliteType.ELITE else ""
		
		for elite in possible_elites:
			if elite.my_id == elite_id:
				possible_elites.erase(elite)
				break
		
		if DebugService.spawn_specific_elite != "":
			elite_id = DebugService.spawn_specific_elite
		
		elites_spawn.push_back([wave, type, elite_id])


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


# Slightly reduce the effect of armor
func get_armor_coef(armor:int)->float:
	var percent_dmg_taken = 10.0 / (10.0 + (abs(armor) / 1.6)) # Was 1.5

	if armor < 0:
		percent_dmg_taken = (1.0 - percent_dmg_taken) + 1.0
	
	return percent_dmg_taken


# Makes Glutton, Spicy Sauce, and Rip and Tear all use the crit stat
func handle_explosion(key:String, pos:Vector2)->void :
	if effects[key].size() > 0:
		var explosion_chance = 0.0
		
		for explosion in effects[key]:
			explosion_chance += explosion.chance
		
		if randf() <= explosion_chance:
			var dmg = 0
			###
			var crit_chance = 0
			###
			var first = effects[key][0]
			var exploding_effect = ExplodingEffect.new()
			
			for explosion in effects[key]:
				var explosion_stats = WeaponService.init_base_stats(explosion.stats, "", [], [exploding_effect])
				dmg += explosion_stats.damage
				### Take the highest calculated crit chance from all the separate explosion sources
				crit_chance = max(crit_chance, explosion_stats.crit_chance)
				###
			
			### Use the newly calculated crit chance
			var _inst = WeaponService.explode(first, pos, dmg, first.stats.accuracy, crit_chance, first.stats.crit_damage, first.stats.burning_data, false, [], first.tracking_text)
			#var _inst = WeaponService.explode(first, pos, dmg, first.stats.accuracy, first.stats.crit_chance, first.stats.crit_damage, first.stats.burning_data, false, [], first.tracking_text)
			###

# Gives an extra starting Sausage for Gun Mage
func add_starting_items_and_weapons()->void :
	if effects["starting_item"].size() > 0:
		for item_id in effects["starting_item"]:
			for i in item_id[1]:
				var item = ItemService.get_element(ItemService.items, item_id[0])
				add_item(item)
				### If adding a starting Sausage, add a 2nd if the starting weapon is an SMG or Shotgun
				if item_id[0] == "item_scared_sausage":
					if RunData.weapons[0].my_id == "weapon_double_barrel_shotgun_1" or RunData.weapons[0].my_id == "weapon_smg_1":
						add_item(item)
				###
	
	if effects["starting_weapon"].size() > 0:
		for weapon_id in effects["starting_weapon"]:
			for i in weapon_id[1]:
				var weapon = ItemService.get_element(ItemService.weapons, weapon_id[0])
				var _weapon = add_weapon(weapon)


# Add new effects to RunData dictionary
func init_effects()->Dictionary:
	var new_effects = {
		"bm_enemy_charge_speed":0,
		"bm_lucky_dmg_when_pickup_gold":[],
		"bm_leftover_materials":0,
		"bm_stats_for_negative_speed":[],
		"bm_increased_burn_duration":0
	}
	var all_effects = .init_effects()
	
	all_effects.merge(new_effects)
	return all_effects

# Add new damage-tracked effects
func init_tracked_effects()->Dictionary:
	var new_effects = {
		"character_lucky":0
	}
	var all_effects = .init_tracked_effects()
	
	all_effects.merge(new_effects)
	return all_effects	
