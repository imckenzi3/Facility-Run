extends CanvasLayer

const INVENTORY_ITEM_SCENE: PackedScene = preload("res://weapons/inventory_item.tscn")#inventory scene

const MIN_HEALTH: int = 23 #store min health

var max_hp: int = 4

@onready var player: CharacterBody2D = get_parent().get_node("Player")			#ref to player 
@onready var health_bar: TextureProgressBar = get_node("HealthBar")				#ref to hpbar
@onready var inventory: HBoxContainer = get_node("PanelContainer/Inventory")	#ref to inventory

func _ready() -> void:
	max_hp = player.hp
	_update_health_bar(100) 

#animates health
func _update_health_bar(new_value: int) -> void:
	var tween: Tween = create_tween()
	tween.tween_property(health_bar, "value", new_value, 0.5).set_trans(Tween.TRANS_QUINT).set_ease(Tween.EASE_OUT)

#updates hp bar
func _on_player_hp_changed(new_hp: int) -> void:
	var new_health: int = int((100 - MIN_HEALTH) * float(new_hp) / max_hp) + MIN_HEALTH
	_update_health_bar(new_health)

#updated weapon switched
func _on_player_weapon_switched(prev_index: int, new_index: int) -> void:
	inventory.get_child(prev_index).deselect()
	inventory.get_child(new_index).select()

#updated weapon pickedup
func _on_player_weapon_picked_up(weapon_texture: Texture) -> void:
	var bnew_inventory_item: TextureRect = INVENTORY_ITEM_SCENE.instantiate()
	inventory.add_child(bnew_inventory_item)
	bnew_inventory_item.initialize(weapon_texture)

#updated weapon droped
func _on_player_weapon_droped(index: int) -> void:
	inventory.get_child(index).queue_free()
