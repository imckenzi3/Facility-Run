extends Node2D

const SPAWN_EXPLOSION_SCENE: PackedScene = preload("res://characters/enemies/spawn_explosion.tscn")

const ENEMY_SCENES: Dictionary = {
	"FLYING_CREATURE": preload("res://characters/enemies/flying enemies/flyingMonkey.tscn")
}

var num_enemies: int

@onready var tilemap: TileMap = get_node("NavigationAgent2D/TileMap2")
@onready var entrance: Node2D = get_node("Entrance")
@onready var door_container: Node2D = get_node("Doors")
@onready var enemy_position_container: Node2D = get_node("EnemyPositions")
@onready var player_detector: Area2D = get_node("PlayerDetector")

func _ready() -> void:
	num_enemies = enemy_position_container.get_child_count()
	
func _on_enemy_killed() -> void:
	num_enemies -= 1
	if num_enemies == 0: #if no more enemies open door
		_open_doors()
	
func _open_doors() -> void:
	for door in door_container.get_children():
		door.open()
		
func _close_entrance() -> void:
	for entry_position in entrance.get_children():
		tilemap.set_cellv(tilemap.world_to_map(entry_position.global_position), 1)
		tilemap.set_cellv(tilemap.world_to_map(entry_position.global_position) + Vector2.UP, 2)

func _spawn_enemies() -> void:
	for enemy_position in enemy_position_container.get_children():
		var enemy: CharacterBody2D = ENEMY_SCENES.FLYING_CREATURE.instantiate()
		#var __ = enemy.connect("tree_exited", self, "_on_enemy_killed") #wont work
		enemy.connect("tree_exited", _on_enemy_killed)
		enemy.global_position = enemy_position.global_position
		call_deferred("add_child", enemy)
		
		var spawn_explosion: AnimatedSprite2D = SPAWN_EXPLOSION_SCENE.instantiate()
		spawn_explosion.global_position = enemy_position.global_position
		call_deferred("add_child", spawn_explosion)
		


func _on_player_detector_body_entered(_body: CharacterBody2D) -> void:
	player_detector.queue_free()
	_close_entrance()
	_spawn_enemies()
	
