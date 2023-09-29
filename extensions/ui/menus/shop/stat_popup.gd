extends "res://ui/menus/shop/stat_popup.gd"

# Tweak Range tooltip
# Add a decimal to armor tooltip for more accuracy
func display_stat(button:Node, title:String, value:int)->void :
	_icon.texture = ItemService.get_stat_icon(title.to_lower())
	_title.text = title
	
	var stat_sign = "POS_" if value >= 0 else "NEG_"
	var key = "INFO_" + stat_sign + title.to_upper()
	
	if title == "STAT_ARMOR":
		### Show one decimal for armor tooltip
		_description.text = Text.text(key, [str(abs(stepify((1.0 - RunData.get_armor_coef(value)) * 100.0, 0.1)))])
		##_description.text = Text.text(key, [str(abs(round((1.0 - RunData.get_armor_coef(value)) * 100.0)))])
		###
	elif title == "STAT_HARVESTING":
		if value >= 0:key += "_LIMITED"
		_description.text = Text.text(key, [str(abs(value)), str(RunData.effects["harvesting_growth"]), str(RunData.nb_of_waves), str(RunData.ENDLESS_HARVESTING_DECREASE)])
	elif title == "STAT_LIFESTEAL":
		_description.text = Text.text(key, [str(abs(value)), "10"])
	elif title == "STAT_HP_REGENERATION":
		var val = RunData.get_hp_regeneration_timer(value)
		var amount = 2 if RunData.effects["double_hp_regen"] else 1
		var amount_per_sec = amount / val
		_description.text = Text.text(key, [str(amount), str(stepify(val, 0.01)), str(stepify(amount_per_sec, 0.01))])
	elif title == "STAT_DODGE":
		_description.text = Text.text(key, [str(abs(value)), str(RunData.effects["dodge_cap"]) + "%"])
	### Use different text key for Range to clarify cooldown
	elif title == "STAT_RANGE":
		key = "NEW_" + key
		_description.text = Text.text(key, [str(abs(value))])
	###
	else :
		_description.text = Text.text(key, [str(abs(value))])
	
	element_from = button
	show()
