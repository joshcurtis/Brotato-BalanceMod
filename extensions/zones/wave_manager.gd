extends "res://zones/wave_manager.gd"

# Adds a new set of Magicians to Wave 14/15 Hordes
func init(p_wave_timer:Timer, wave_data:Resource)->void :
	wave_timer = p_wave_timer
	current_wave_data = wave_data
	###
	var new_group_to_add = load("res://mods-unpacked/DarkTwinge-BalanceMod/waves/horde_group_magician-spawner.tres")
	horde_groups.push_back(new_group_to_add)
	###
	
	if DebugService.debug_enemies.size() > 0:
		current_wave_data.groups_data = debug_groups
		debug_groups[0].wave_units_data = DebugService.debug_enemies
	
	
	if DebugService.no_enemies:
		current_wave_data.groups_data = []
		return 
	
	for group_data in groups_data_in_all_waves:
		current_wave_data.groups_data.push_back(group_data)
	
	if RunData.effects["extra_enemies_next_wave"] > 0:
		for i in RunData.effects["extra_enemies_next_wave"]:
			for group in extra_groups:
				current_wave_data.groups_data.push_back(group)
		RunData.effects["extra_enemies_next_wave"] = 0
	
	if RunData.effects["extra_loot_aliens_next_wave"] > 0:
		
		for i in RunData.effects["extra_loot_aliens_next_wave"]:
			for group in loot_alien_groups:
				var new_group = group.duplicate()
				new_group.spawn_timing = rand_range(5, wave_timer.time_left - 10)
				current_wave_data.groups_data.push_back(new_group)
		
		RunData.effects["extra_loot_aliens_next_wave"] = 0
	
	var groups_to_add = []
	
	for group_data in wave_data.groups_data:
		if group_data.is_boss and RunData.current_wave > RunData.nb_of_waves:
			var local_elite_group = init_elite_group()
			groups_to_add.push_back(local_elite_group)
	
	if RunData.elites_spawn.size() > 0:
		for elite_spawn in RunData.elites_spawn:
			if RunData.current_wave == (elite_spawn[0] as int):
				_is_elite_wave = true
				_elite_spawn_data = elite_spawn
				
				if elite_spawn[1] == EliteType.ELITE:
					var local_elite_group = init_elite_group([elite_spawn[2]])
					groups_to_add.push_back(local_elite_group)
				elif elite_spawn[1] == EliteType.HORDE:
					for group_data in horde_groups:
						if RunData.current_wave >= group_data.min_wave and RunData.current_wave <= group_data.max_wave:
							groups_to_add.push_back(group_data)
				break
	
	for group_to_add in groups_to_add:
		current_wave_data.groups_data.push_back(group_to_add)
