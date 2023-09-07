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


# change shop item icons when Fairy purchased
func on_shop_item_bought(shop_item:ShopItem)->void :
	for item in _shop_items:
		if item[0].my_id == shop_item.item_data.my_id and item[0].my_id == "item_fairy":
			print("okay do it")
	.on_shop_item_bought(shop_item)
	
