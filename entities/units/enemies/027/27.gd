extends Boss

var CHARGING_PROJECTILES_COOLDOWN = 45.0
var current_projectiles_cooldown = 0.0
var current_charging_projectile_behavior = null

onready var _charging_shoot_projectiles_behavior = $ChargingShootProjectilesBehavior
onready var _charging_shoot_projectiles_behavior_2 = $ChargingShootProjectilesBehavior2

# Same as vanilla
func _ready()->void :
	_charging_shoot_projectiles_behavior.init(self)
	_charging_shoot_projectiles_behavior_2.init(self)
	
	current_charging_projectile_behavior = _charging_shoot_projectiles_behavior

# Same as vanilla
func _physics_process(delta:float)->void :
	current_projectiles_cooldown = max(0.0, current_projectiles_cooldown - Utils.physics_one(delta))
	
	if _move_locked and current_projectiles_cooldown <= 0.0 and not dead:
		current_projectiles_cooldown = CHARGING_PROJECTILES_COOLDOWN
		current_charging_projectile_behavior.shoot()


# Replaces existing function to increase cooldown for Phase 2
func on_state_changed(new_state:int)->void :
	.on_state_changed(new_state)
	
	if new_state == 0:
		CHARGING_PROJECTILES_COOLDOWN = 55.0  ## 45.0
		current_charging_projectile_behavior = _charging_shoot_projectiles_behavior_2