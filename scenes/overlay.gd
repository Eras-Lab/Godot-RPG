extends CanvasLayer


func _ready():
	for character in PlayerStatus.get_characters():
		update_stats(character)
		populate_inventory(character)

#Synchronizes the UI with the latest state of the Charcter Dictionary
func update_stats(num):
	var characterNode = get_node("Character" + str(num))
	var character = PlayerStatus.get_character(num)

	var nameContainer = characterNode.get_node("NameContainer")
	nameContainer.get_node("Name").text = character.name

	var statsContainer = characterNode.get_node("StatsPanel").get_node("StatsContainer")
	statsContainer.get_node("Stamina").text = "Stamina: " + str(character.stamina)
	statsContainer.get_node("Strength").text = "Strength: " + str(character.strength)
	statsContainer.get_node("Constitution").text = "Constitution: " + str(character.constitution)
	statsContainer.get_node("Dexterity").text = "Dexterity: " + str(character.dexterity)
	statsContainer.get_node("Intelligence").text = "Intelligence: " + str(character.intelligence)
	statsContainer.get_node("AttackDamage").text = "Attack Damage: " + str(character.attack_damage)
	statsContainer.get_node("Defense").text = "Defense: " + str(character.defense)

	var health = characterNode.get_node("Health")
	health.get_node("HealthBar").max_value = character.max_health
	health.get_node("HealthBar").value = character.health
	health.get_node("Value").text = str(character.health) + "/" + str(character.max_health)

	var experience = characterNode.get_node("Experience")
	experience.get_node("ExpBar").value = character.experience
	experience.get_node("Value").text = str(character.experience)

	characterNode.get_node("Gold").get_node("Value").text = "Gold: " + str(character.gold)
	characterNode.get_node("Kills").get_node("Value").text = "Monster Kills: " + str(character.kills)

#Synchronizes the Inventory UI with the latest state of the Inventory Resource in the Character Dictionary
func populate_inventory(num):
	var characterNode = get_node("Character" + str(num))
	var inventory = characterNode.get_node("InventoryPanel").get_node("Inventory")
	var equipped_items = characterNode.get_node("EquippedItemsPanel").get_node("EquippedItems")
	var character = PlayerStatus.get_character(num)
	
	inventory.set_inventory_data(character.inventory)
	equipped_items.set_inventory_data(character.equipped_items)

#Toggle Overlay
func _unhandled_input(event):
	if Input.is_action_just_pressed("inventory"):
		self.visible = !self.visible
		
func _on_toggle_character_1_pressed():
	$Character1.show()
	$Character2.hide()

func _on_toggle_character_2_pressed():
	$Character2.show()
	$Character1.hide()
