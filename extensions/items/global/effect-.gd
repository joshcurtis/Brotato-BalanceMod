extends "res://items/global/effect.gd"

# Replace to change tooltip for King's modified abilities
func get_arg_value(from_arg_value:int, p_base_value:String)->String:
	var final_value = p_base_value
	
	if from_arg_value != ArgValue.USUAL:
		match from_arg_value:
			ArgValue.VALUE:final_value = str(value)
			ArgValue.KEY:final_value = str(tr(key.to_upper()))
			ArgValue.UNIQUE_WEAPONS:
				var nb = RunData.get_unique_weapon_ids().size()
				final_value = str(value * nb)
			ArgValue.ADDITIONAL_WEAPONS:
				var nb = RunData.weapons.size()
				final_value = str(value * nb)
			ArgValue.TIER:
				var val = "TIER_I"
				if value == 1:val = "TIER_II"
				elif value == 2:val = "TIER_III"
				elif value == 3:val = "TIER_IV"
				final_value = tr(val)
			ArgValue.SCALING_STAT:
				final_value = Utils.get_scaling_stat_text(key, value / 100.0)
			ArgValue.SCALING_STAT_VALUE:
				final_value = str(WeaponService.get_scaling_stats_value([[key, value / 100.0]]))
			ArgValue.MAX_NB_OF_WAVES:
				final_value = str(RunData.nb_of_waves)
			ArgValue.TIER_IV_WEAPONS:
				### Now counts uniques rather than total tier-4s
				var unique_tier4_weapon_ids = []
				for weapon in RunData.weapons:
					if weapon.tier >= Tier.LEGENDARY: 
						if not unique_tier4_weapon_ids.has(weapon.weapon_id):
							unique_tier4_weapon_ids.push_back(weapon.weapon_id)
				final_value = str(value * unique_tier4_weapon_ids.size())
				###
			ArgValue.TIER_I_WEAPONS:
				var nb_tier_i_weapons = 0
				for weapon in RunData.weapons:
					if weapon.tier <= Tier.COMMON:
						nb_tier_i_weapons += 1
				final_value = str(value * nb_tier_i_weapons)
			_:print("wrong value")
	return final_value
