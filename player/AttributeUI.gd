extends VBoxContainer
@onready var attribute_ui = $"."
@onready var player_status = $"../../PlayerStatus"


# Called when the node enters the scene tree for the first time.
func _ready():
	updateAttributeUI()

func updateAttributeUI():
	for child in attribute_ui.get_children():
		attribute_ui.remove_child(child)
		child.queue_free()
	
	var characterAttributes = player_status.get_player_stats()
	for attribute in characterAttributes:
		var marginContainer = MarginContainer.new()
		var attributeContainer = HBoxContainer.new()
		
		var key = attribute.keys()[0]
		var value = str(attribute[key])
		
		var nameLabel = Label.new()
		nameLabel.text = key
		attributeContainer.add_child(nameLabel)
		
		var valueLabel = Label.new()
		valueLabel.text = value
		attributeContainer.add_child(valueLabel)
		
		attributeContainer.add_theme_constant_override("separation", 10)
		marginContainer.add_child(attributeContainer)
#		marginContainer.add_theme_constant_override("margin_top", 80)
		
		self.add_child(marginContainer)
		
		
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
