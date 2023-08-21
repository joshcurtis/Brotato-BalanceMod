extends "res://singletons/linked_stats.gd"

# Append; Streamer now gets +2 Armor from Pocket Factory
func reset()->void :
	.reset()
	for linked_stat in RunData.effects["stat_links"]:
		var stat_to_tweak = linked_stat[0]
		#var stat_scaled = 0
		
		if linked_stat[2] == "structure":
			# If Pocket Factory, Add 2 to armor
			if RunData.effects["tree_turrets"] > 0:
				add_stat(stat_to_tweak, 2)
