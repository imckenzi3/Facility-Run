extends Enemy

const THROWEABLE_LIGHTNING_SCENE: PackedScene = preload("res://characters/enemies/ranged enemies/throwable_thunder.tscn")

const MAX_DISTANCE_TO_PLAYER: int = 80 #max distance to player that robot can be to player
const MIN_DISTANCE_TO_PLAYER: int = 40 #min

@export var throwable_speed: int = 150

var can_attack: bool = true

var distance_to_player: float

@onready var attack_timer: Timer = get_node("AttackTimer")
@onready var aim_raycast: RayCast2D = get_node("AimRayCast2D")

func _on_PathTimer_timeout() -> void:
	if is_instance_valid(player):
		distance_to_player = (player.position - global_position).length()
		if distance_to_player > MAX_DISTANCE_TO_PLAYER:
			_get_path_to_player()
		elif distance_to_player < MIN_DISTANCE_TO_PLAYER:
			_get_path_to_move_away_from_player()
			
			#if the enemy is not too close or too far away
			#check if can_attack is true
		else:
			aim_raycast.target_position = player.position - global_position
			if can_attack and state_machine.state == state_machine.states.idle and not aim_raycast.is_colliding():
				can_attack = false
				_throw_thunder()
				attack_timer.start()
	else:
		move_direction = Vector2.ZERO

#move away from player
func _get_path_to_move_away_from_player() -> void:
	var dir: Vector2 = (global_position - player.position).normalized()
	nav_agent.target_position = global_position + dir * 100

#attacking 
func _throw_thunder() -> void:
	var thunder: Area2D = THROWEABLE_LIGHTNING_SCENE.instantiate()
	thunder.launch(global_position, (player.position - global_position).normalized(), throwable_speed)
	get_tree().current_scene.add_child(thunder)

func _on_attack_timer_timeout() -> void:
	can_attack = true
