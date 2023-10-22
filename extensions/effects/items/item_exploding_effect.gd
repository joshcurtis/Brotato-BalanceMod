extends "res://effects/items/item_exploding_effect.gd"

func get_args()->Array:
	var current_stats = WeaponService.init_base_stats(stats, "", [], [ExplodingEffect.new()])
	var scaling_text = WeaponService.get_scaling_stats_icons(stats.scaling_stats)
	return [str(chance * 100.0), str(current_stats.damage), scaling_text, str(round(scale * 100.0))]
