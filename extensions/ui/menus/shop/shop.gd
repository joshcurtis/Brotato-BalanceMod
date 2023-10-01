extends "res://ui/menus/shop/shop.gd"

# Bugfix: Update stats on reroll
func _on_RerollButton_pressed()->void :
	if RunData.gold >= _reroll_price and RunData.locked_shop_items.size() < ItemService.NB_SHOP_ITEMS:
		RunData.remove_gold(_reroll_price)
		
		if RunData.locked_shop_items.size() > 0:
			fill_shop_items_when_locked(RunData.locked_shop_items)
		else :
			_shop_items = ItemService.get_shop_items(RunData.current_wave, ItemService.NB_SHOP_ITEMS, _shop_items)
		
		_shop_items_container.set_shop_items(_shop_items)
		
		for i in RunData.locked_shop_items.size():
			_shop_items_container.lock_shop_item_visually(i)
		
		set_reroll_button_price()
		###
		_stats_container.update_stats()
		###
		
		_shop_items_container.update_buttons_color()


# Append to refresh weapon label when buying Robot Arm
func on_shop_item_bought(shop_item)->void :
	.on_shop_item_bought(shop_item)
	print("id  ", shop_item.item_data.my_id)
	if shop_item.item_data.my_id == "item_robot_arm":
		_weapons_container.set_label(get_weapons_label_text())
