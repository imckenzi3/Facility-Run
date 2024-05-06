extends PointLight2D

@onready var interaction_area = $InteractionArea
@onready var sprite = $Sprite2D

func _ready():
	interaction_area.interact = Callable(self, "_toggle_lamp")

func _toggle_lamp():
	enabled = false if enabled == true else true #set light to false if turned off
	
