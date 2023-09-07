extends "res://global/entity_spawner.gd"

var total_spawn_count = 0

# Overwrite - Normalize enemy spawns so there isn't the extreme variance for e.g. Jack
func on_group_spawn_timing_reached(group_data:WaveGroupData, _is_elite_wave:bool)->void :
	
	if enemies.size() > _current_wave_data.max_enemies:
		var nb_to_remove = enemies.size() - _current_wave_data.max_enemies
		
		for i in nb_to_remove:
			var en = Utils.get_rand_element(enemies)
			en.can_drop_loot = false
			en.die()
			enemies_removed_for_perf += 1
	
	var group_pos:Vector2 = get_group_pos(group_data)
	
	var units_data = group_data.wave_units_data
	
	if group_data.is_boss and not RunData.effects["double_boss"] and RunData.current_wave == RunData.nb_of_waves:
		units_data = [Utils.get_rand_element(units_data)]
	
	var global_mod = 1.0
	
	
	for unit_wave_data in units_data:
		var mod = 0
		var flat_mod = 0
		
		if unit_wave_data.type == EntityType.ENEMY:
			mod += (RunData.effects["number_of_enemies"] / 100.0)
		elif unit_wave_data.type == EntityType.NEUTRAL:
			flat_mod += RunData.effects["trees"]
		
		var min_nb = (unit_wave_data.min_number + flat_mod)
		var max_nb = (unit_wave_data.max_number + flat_mod)
		
		var number = (Utils.get_random_int(min_nb, max_nb) * global_mod) as int
		
		if mod < 0 and number > 1:
			var nb_to_remove = 0
			
			for i in number:
				if randf() < abs(mod):
					nb_to_remove += 1
			
			number = max(1, number - nb_to_remove)
		elif mod > 0:
			var nb_to_add = 0
			var additionals = (max(0, number * (mod - 1)))
			
			
			for i in (number + additionals) as int:
				if randf() < abs(mod):
					nb_to_add += 1
			
			number += nb_to_add
		
		if group_data.is_neutral:
			
			var total_chance:float = number * unit_wave_data.spawn_chance
			var nb = floor(total_chance)
			var residual_chance:float = total_chance - nb
			
			if randf() <= residual_chance:
				nb += 1
			
			for i in nb:
				var spawn_pos = get_spawn_pos_in_area(group_pos, group_data.area, group_data.spawn_dist_away_from_edges, group_data.spawn_edge_of_map)
			
				while spawn_pos.distance_to(_player.global_position) < MIN_DIST_FROM_PLAYER:
					spawn_pos = get_spawn_pos_in_area(group_pos, - 1, group_data.spawn_dist_away_from_edges, group_data.spawn_edge_of_map)
				
				queue_to_spawn_trees.push_back([unit_wave_data.type, unit_wave_data.unit_scene, spawn_pos])
		else :
			###
			print("~~~")
			for i in number:
				if randf() <= unit_wave_data.spawn_chance:
					###
					total_spawn_count += 1
					var spawn_pos = get_spawn_pos_in_area(group_pos, group_data.area, group_data.spawn_dist_away_from_edges, group_data.spawn_edge_of_map)
					
					while spawn_pos.distance_to(_player.global_position) < MIN_DIST_FROM_PLAYER:
						spawn_pos = get_spawn_pos_in_area(group_pos, - 1, group_data.spawn_dist_away_from_edges, group_data.spawn_edge_of_map)
					
					if group_data.is_boss:
						queue_to_spawn_bosses.push_back([unit_wave_data.type, unit_wave_data.unit_scene, spawn_pos])
					else :
						queue_to_spawn.push_back([unit_wave_data.type, unit_wave_data.unit_scene, spawn_pos])
		
		print(total_spawn_count)
