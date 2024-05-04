extends Room

const WEAPONS: Array = [preload("res://weapons/crowbar.tscn"), preload("res://Weapons/gun1.tscn")]

@onready var weapon_pos: Marker2D = get_node("WeaponPos")

func _ready() -> void:
	var weapon: Node2D = WEAPONS[randi() % WEAPONS.size()].instantiate()
	weapon.position = weapon_pos.position
	weapon.on_floor = true
	add_child(weapon)
