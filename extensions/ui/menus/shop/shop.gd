extends "res://ui/menus/shop/shop.gd"

## [Bugfix: Update stats on reroll] Removed - Now live in vanilla


# Append to refresh weapon label when buying Robot Arm
func on_shop_item_bought(shop_item)->void :
	.on_shop_item_bought(shop_item)
	if shop_item.item_data.my_id == "item_robot_arm":
		_weapons_container.set_label(get_weapons_label_text())


# Append to refresh shop items on weapon combine for King's ability
func on_item_combine_button_pressed(weapon_data:WeaponData, is_upgrade:bool = false)->void :
	.on_item_combine_button_pressed(weapon_data, is_upgrade)
	# Don't refresh if upgrade is from Anvil
	if not is_upgrade:
		_shop_items_container.reload_shop_items_descriptions()
