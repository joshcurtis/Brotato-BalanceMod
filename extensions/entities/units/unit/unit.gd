extends "res://entities/units/unit/unit.gd"

# Averages two vector directions with weighting, used for Knockback changes
func _lerp(a:Vector2, b:Vector2, weight:float)->Vector2:
	return b*weight + (1-weight)*a

# Replaces function:
# Changes knockback direction calculation
# No longer uses up Tardigrade for 1 damage hits
func take_damage(value:int, hitbox:Hitbox = null, dodgeable:bool = true, armor_applied:bool = true, custom_sound:Resource = null, base_effect_scale:float = 1.0)->Array:
	if dead:
		return [0, 0]
	
	var crit_damage = 0.0
	var crit_chance = 0.0
	var knockback_direction = Vector2.ZERO
	var knockback_amount = 0.0
	var effect_scale = base_effect_scale
	var dmg_dealt = 0
	
	if hitbox != null:
		crit_damage = hitbox.crit_damage
		crit_chance = hitbox.crit_chance
		knockback_direction = hitbox.knockback_direction
		### Makes knockback an average of existing game behavior and the vector from player to enemy
		if player_ref != null:
			var out_from_player = global_position.direction_to(player_ref.global_position)
			knockback_direction = _lerp(out_from_player, knockback_direction, 0.5)
		###
		knockback_amount = hitbox.knockback_amount
		effect_scale = hitbox.effect_scale
	
	var is_crit = false
	var is_miss = false
	var is_dodge = false
	var is_protected = false

	var full_dmg_value = get_dmg_value(value, armor_applied)
	

	if dodgeable and randf() < min(current_stats.dodge, RunData.effects["dodge_cap"] / 100.0):
		full_dmg_value = 0
		is_dodge = true
	### Add a check for damage to be at least 2 to activate Tardigrade
	elif (_hit_protection > 0) and (full_dmg_value >= 2):
	#elif (_hit_protection > 0):
	###
		_hit_protection -= 1
		full_dmg_value = 0
		is_protected = true
	else :
		flash()
	
	var sound = Utils.get_rand_element(hurt_sounds)
	
	if full_dmg_value == 0:
		sound = Utils.get_rand_element(dodge_sounds)
	elif not is_miss and randf() < crit_chance:
		
		full_dmg_value = get_dmg_value(round(value * crit_damage) as int, true, true)
		
		dmg_dealt = clamp(full_dmg_value, 0, current_stats.health)
		
		if hitbox:
			hitbox.critically_hit_something(self, dmg_dealt)
		
		is_crit = true
		sound = Utils.get_rand_element(crit_sounds)
	
	if custom_sound:
		sound = custom_sound
	
	SoundManager2D.play(sound, global_position, 0, 0.2, always_play_hurt_sound)
	
	dmg_dealt = clamp(full_dmg_value, 0, current_stats.health)
	current_stats.health = max(0.0, current_stats.health - full_dmg_value) as int
	
	_knockback_vector = knockback_direction * knockback_amount
	
	emit_signal("health_updated", current_stats.health, max_stats.health)
	
	var hit_type = HitType.NORMAL
	
	if current_stats.health <= 0:
		if hitbox:
			hitbox.killed_something(self)
		die(knockback_direction * max(knockback_amount, MIN_DEATH_KNOCKBACK_AMOUNT))
		
		if is_crit:
			var gold_added = 0
			
			for effect in RunData.effects["gold_on_crit_kill"]:
				if randf() <= effect[1] / 100.0:
					gold_added += 1
					RunData.tracked_item_effects["item_hunting_trophy"] += 1
			
			if RunData.effects["heal_on_crit_kill"] > 0:
				if randf() <= RunData.effects["heal_on_crit_kill"] / 100.0:
					RunData.emit_signal("healing_effect", 1, "item_tentacle")
			
			for effect in hitbox.effects:
				if effect.key == "gold_on_crit_kill" and randf() <= effect.value / 100.0:
					gold_added += 1
					hitbox.added_gold_on_crit(gold_added)
			
			if gold_added > 0:
				RunData.add_gold(gold_added)
				hit_type = HitType.GOLD_ON_CRIT_KILL
	
	emit_signal(
		"took_damage", 
		self, 
		full_dmg_value, 
		knockback_direction, 
		knockback_amount, 
		is_crit, 
		is_miss, 
		is_dodge, 
		is_protected, 
		effect_scale, 
		hit_type
	)
	
	return [full_dmg_value, dmg_dealt, is_dodge]
