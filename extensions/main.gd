extends "res://main.gd"

# Replace to reduce Horde Wave profits
func spawn_loot(unit:Unit, entity_type:int)->void :
	
	if not unit.can_drop_loot:
		return 
	
	if unit.stats.can_drop_consumables:
		spawn_consumables(unit)
	
	var gold_drops = (RunData.effects["gold_drops"] / 100.0)
	
	if entity_type == EntityType.ENEMY:
		gold_drops += RunData.effects["enemy_gold_drops"] / 100.0
	
	var wave_factor = RunData.current_wave * 0.015
	var diff_factor = (RunData.effects["diff_gold_drops"] / 100.0)
	var spawn_chance = (1.0 + diff_factor) * gold_drops if (RunData.current_wave < 5) else max(0.5 * gold_drops, (1.0 - wave_factor + diff_factor) * gold_drops)
	
	if _is_horde_wave:
		### 0.65 -> 0.6
		spawn_chance *= 0.6
		##
	
	if unit.stats.always_drop_consumables:
		spawn_chance = 1.0
	
	if entity_type == EntityType.ENEMY and randf() > spawn_chance:
		return 
	
	if _golds.size() > MAX_GOLDS:
		var gold_boosted = Utils.get_rand_element(_golds)
		gold_boosted.value += unit.stats.value
		gold_boosted.scale += Vector2(unit.stats.value * 0.05, unit.stats.value * 0.05)
	else :
		spawn_gold(unit, entity_type)

# Replace, Splits Lucky & Baby Elephant
func on_gold_picked_up(gold:Node)->void :
	_golds.erase(gold)
	if ProgressData.settings.alt_gold_sounds:
		SoundManager.play(Utils.get_rand_element(gold_alt_pickup_sounds), - 5, 0.2)
	else :
		SoundManager.play(Utils.get_rand_element(gold_pickup_sounds), 0, 0.2)
	
	var value = gold.value
	
	if randf() < RunData.effects["chance_double_gold"] / 100.0:
		RunData.tracked_item_effects["item_metal_detector"] += value
		value *= 2
		gold.boosted *= 2
	
	if randf() < RunData.effects["heal_when_pickup_gold"] / 100.0:
		RunData.emit_signal("healing_effect", 1, "item_cute_monkey")
	
	if gold.attracted_by == _player:
		
		if RunData.effects["dmg_when_pickup_gold"].size() > 0:
			var dmg_taken = handle_stat_damages(RunData.effects["dmg_when_pickup_gold"])
			RunData.tracked_item_effects["item_baby_elephant"] += dmg_taken[1]
		### Split Lucky effect from Baby Elephant
		if RunData.effects["bm_lucky_dmg_when_pickup_gold"].size() > 0:
			var dmg_taken = handle_stat_damages(RunData.effects["bm_lucky_dmg_when_pickup_gold"])
			RunData.tracked_item_effects["character_lucky"] += dmg_taken[1]
		###
		
		RunData.add_gold(value)
		RunData.add_xp(value)
		ProgressData.add_data("materials_collected")
	else :
		RunData.add_bonus_gold(value)

# Apprend to save next-wave mats for new Padding
func clean_up_room(is_last_wave:bool = false, is_run_lost:bool = false, is_run_won:bool = false)->void :
	.clean_up_room(is_last_wave, is_run_lost, is_run_won)
	
	RunData.effects["bm_leftover_materials"] = RunData.bonus_gold

