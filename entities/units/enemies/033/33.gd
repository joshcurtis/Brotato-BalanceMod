extends Boss

onready var _spawning_shooting_behavior = $SpawningShootingBehavior
onready var mom_counter = 1

# Same as vanilla
func _ready()->void :
	_spawning_shooting_behavior.init(self)

# Replaces existing function with new layered logic
func shoot()->void :
	_current_attack_behavior.shoot()
	
	# base time between attacks is 24 frames from the animation, plus the cooldown amount in 33.tscn
	if _current_state == 0:
		_current_attack_behavior.cooldown = 16.0
		
		# Seven steps summoning-focused
		if mom_counter <= 7:
			_current_attack_behavior.nb_to_spawn = 6 # summons = 9 per second
			# Every other 0.67s cause a slice
			if (mom_counter % 2) == 0:
				_spawning_shooting_behavior.shoot() # Slice
		# Nine steps slash-focused
		elif mom_counter > 7:
			_current_attack_behavior.nb_to_spawn = 2 # summons = 3 per second
			_spawning_shooting_behavior.shoot() # Slice
		# Reset to start the high summons again
		if mom_counter >= 16:
			mom_counter = 0
		
		mom_counter += 1