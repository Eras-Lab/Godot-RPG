extends Node
@onready var player = $".."
@onready var notifications = $"../Notifications"

func craft(recipe: CraftRecipe):
	#TODO:
	#Allow the use of stackable items and handle logic accordingly
	var has_all_ingredients = true
	
	var item_datas = []
	for item in player.inventory_data.slot_datas:
		item_datas.push_back(item.item_data)
		
	for ingredient in recipe.ingredients:
		if !item_datas.has(ingredient):
			print("does not have ingredient: ", ingredient)
			has_all_ingredients = false
	
	if has_all_ingredients:
		for ingredient in recipe.ingredients:
			var index = item_datas.find(ingredient)
			player.inventory_data.slot_datas[index].item_data = null
		var empty_slot = player.inventory_data.find_empty_slot()
		player.inventory_data.slot_datas[empty_slot].item_data = recipe.result
		print("player crafting: ", player)
		notifications.handle_item_notification(recipe.result, "craft")
