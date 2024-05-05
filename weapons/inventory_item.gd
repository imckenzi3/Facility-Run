extends TextureRect

@onready var border: ReferenceRect = get_node("ReferenceRect")

func initialize(texture: Texture) -> void:
	self.texture = texture
	
func select() -> void: #selecting item
	border.show()
	
func deselect() -> void:
	border.hide()
