extends Control

signal drop_slot_data(slot_data: SlotData)

var grabbed_slot_data: SlotData
var external_inventory_owner

@onready var player_inventory = $PlayerInventory
@onready var grabbed_slot = $GrabbedSlot
@onready var external_inventory = $ExternalInventory
@onready var equip_inventory = $EquipInventory
@onready var player_inventory_2 = $PlayerInventory2
@onready var equip_inventory_2 = $EquipInventory2
@onready var player_inventory_3 = $PlayerInventory3
@onready var equip_inventory_3 = $EquipInventory3
@onready var player_inventory_4 = $PlayerInventory4
@onready var equip_inventory_4 = $EquipInventory4
@onready var player_inventory_5 = $PlayerInventory5
@onready var equip_inventory_5 = $EquipInventory5


func _physics_process(delta):
	if grabbed_slot.visible:
		grabbed_slot.global_position = get_global_mouse_position() + Vector2(5, 5)

func set_player_inventory_data(inventory_data: InventoryData, player) -> void:
	inventory_data.inventory_interact.connect(on_inventory_interact)
	if player == 1:
		player_inventory.set_inventory_data(inventory_data)
		player_inventory.set_player(1)

	elif player == 2:
		player_inventory_2.set_inventory_data(inventory_data)
		player_inventory_2.set_player(2)
	elif player == 3:
		player_inventory_3.set_inventory_data(inventory_data)
		player_inventory_3.set_player(3)
	elif player == 4:
		player_inventory_4.set_inventory_data(inventory_data)
		player_inventory_4.set_player(4)
	elif player == 5:
		player_inventory_5.set_inventory_data(inventory_data)
		player_inventory_5.set_player(5)

func set_equip_inventory_data(inventory_data: InventoryData, player: int) -> void:
	inventory_data.inventory_interact.connect(on_inventory_interact)
	if player == 1:
		equip_inventory.set_inventory_data(inventory_data)
	elif player == 2:
		equip_inventory_2.set_inventory_data(inventory_data)
	elif player == 3:
		equip_inventory_3.set_inventory_data(inventory_data)
	elif player == 4:
		equip_inventory_4.set_inventory_data(inventory_data)
	elif player == 5:
		equip_inventory_5.set_inventory_data(inventory_data)

func on_inventory_interact(inventory_data: InventoryData, index: int, button: int) -> void:
		pass
#	print("this is the inventory %s ", inventory_data.player)
#	var player = inventory_data.player
#	match [grabbed_slot_data, button]:
#		[null, MOUSE_BUTTON_LEFT]:
#			inventory_data.equip_item(index)
#		[_, MOUSE_BUTTON_LEFT]:
#			grabbed_slot_data = inventory_data.drop_slot_data(grabbed_slot_data, index)
#		[null, MOUSE_BUTTON_RIGHT]:
#			inventory_data.use_slot_data(index)
#		[_, MOUSE_BUTTON_RIGHT]:
#			grabbed_slot_data = inventory_data.drop_single_slot_data(grabbed_slot_data, index)
#	update_grabbed_slot()

func update_grabbed_slot() -> void:
	if grabbed_slot_data:
		grabbed_slot.show()
		grabbed_slot.set_slot_data(grabbed_slot_data)
	else:
		grabbed_slot.hide()

func set_external_inventory(_external_inventory_owner) -> void:
	external_inventory_owner = _external_inventory_owner
	var inventory_data = external_inventory_owner.inventory_data

	inventory_data.inventory_interact.connect(on_inventory_interact)
	external_inventory.set_inventory_data(inventory_data)

	external_inventory.show()

func clear_external_inventory() -> void:
	if external_inventory_owner:
		var inventory_data = external_inventory_owner.inventory_data

		inventory_data.inventory_interact.disconnect(on_inventory_interact)
		external_inventory.clear_inventory_data(inventory_data)

		external_inventory.hide()
		external_inventory_owner = null


func _on_gui_input(event):
	if event is InputEventMouseButton \
			and event.is_pressed() \
			and grabbed_slot_data:

		match event.button_index:
			MOUSE_BUTTON_LEFT:
				drop_slot_data.emit(grabbed_slot_data)
				grabbed_slot_data = null
			MOUSE_BUTTON_RIGHT:
				drop_slot_data.emit(grabbed_slot_data.create_single_slot_data())
				if grabbed_slot_data.quantity < 1:
					grabbed_slot_data = null

		update_grabbed_slot()


func _on_visibility_changed():
	if not visible and grabbed_slot_data:
		drop_slot_data.emit(grabbed_slot_data)
		grabbed_slot_data = null
		update_grabbed_slot()
