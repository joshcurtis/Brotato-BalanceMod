extends "res://entities/units/enemies/attack_behaviors/charging_attack_behavior.gd"

# Applies new Snail effect to slow charging speed
func shoot()->void :
	.shoot()
	if RunData.effects["bm_enemy_charge_speed"]:
		_parent.bonus_speed *= (1 + (RunData.effects["bm_enemy_charge_speed"] / 100.0))
