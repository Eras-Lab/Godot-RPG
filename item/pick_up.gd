extends Node2D

@export var slot_data: SlotData
var item_data: ItemData
@onready var sprite_2d = $Sprite2D

func _on_area_2d_body_entered(body):
	if body.has_method("player") and body.inventory_data.pick_up_slot_data(slot_data):
		queue_free()

func set_item_data(_item_data):
	item_data = _item_data
	get_node("Sprite2D").texture = _item_data.texture
