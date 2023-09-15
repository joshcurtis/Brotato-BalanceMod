extends "res://singletons/run_data.gd"

# New function for counting unique tier-4s, King's changed ability
func get_unique_tier4_weapon_ids()->Array:
	var unique_tier4_weapon_ids = []
	
	for weapon in weapons:
		if weapon.tier >= Tier.LEGENDARY: 
			if not unique_tier4_weapon_ids.has(weapon.weapon_id):
				unique_tier4_weapon_ids.push_back(weapon.weapon_id)
	
	return unique_tier4_weapon_ids

# Replaced fuction for applying unique tier-4s, King's changed ability
func update_tier_iv_weapon_bonuses()->void :
	
	for effect in tier_iv_weapon_effects:
		effects[effect[0]] -= effect[1]
	
	tier_iv_weapon_effects = []
	var unique_tier4_weapon_ids = get_unique_tier4_weapon_ids()
	
	for i in unique_tier4_weapon_ids.size():
		for effect in effects["tier_iv_weapon_effects"]:
			effects[effect[0]] += effect[1]
			tier_iv_weapon_effects.push_back(effect)



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
		"bm_lucky_dmg_when_pickup_gold":[]
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
