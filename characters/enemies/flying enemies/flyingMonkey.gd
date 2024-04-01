extends Enemy

@onready var hitbox: Area2D = get_node("Hitbox") #var for hitbox

#update knockback direction of the hitbox with the normalized velocity
func _process(_delta: float) -> void:
	hitbox.knockback_direction = velocity.normalized()
