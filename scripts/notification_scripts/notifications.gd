extends Node
@onready var notifications = $"."

var displayedNotifications = []
var notificationPosition = Vector2(-20,-80)

var notificationScene = preload("res://scenes/notifications.tscn")

func handle_item_notification(item_data: ItemData, action: String):
	if displayedNotifications.size() > 0:
		var currentHeight = displayedNotifications[displayedNotifications.size() - 1].size.y
		notificationPosition.y += currentHeight + 10
	
	var notificationInstance = notificationScene.instantiate()
	notificationInstance.position = notificationPosition
	displayedNotifications.append(notificationInstance)
	
	var text = ""
	if action == "use":
		text = "<Used " + item_data.name + ">"
	elif action == "equip":
		text = "<Equipped " + item_data.name + ">"
	elif action == "unequip":
		text = "<Unequipped " + item_data.name + ">"
	elif action == "buy":
		text = "<Bought " + item_data.name + ">"
	elif action == "sell":
		text = "<Sold " + item_data.name + ">"
		
	notificationInstance.get_node("Control/Label").text = text
	notificationInstance.get_node("Control/TextureRect").texture = item_data.texture

	notifications.add_child(notificationInstance)
	notificationInstance.get_node("Timer").start()
	
	if displayedNotifications.size() > 5:
		removeNotification(displayedNotifications[0])

func handle_combat_notification(enemy):
	pass

func removeNotification(notification):
	print("remove notification", notification)
	notification.get_node("Timer").stop()
	notification.queue_free()
	displayedNotifications.erase(notification)
