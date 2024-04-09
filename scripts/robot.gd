extends Enemy

const MAX_DISTANCE_TO_PLAYER: int = 80 #max distance to player that robot can be to player
const MIN_DISTANCE_TO_PLAYER: int = 40 #min

var distance_to_player: float

func _on_PathTimer_timeout() -> void: 
	if is_instance_valid(player):
		distance_to_player = (player.position - global_position).length()
		if distance_to_player > MAX_DISTANCE_TO_PLAYER:
			_get_path_to_player()
		elif distance_to_player < MIN_DISTANCE_TO_PLAYER:
			_get_path_to_move_away_from_player()
	else:
		move_direction = Vector2.ZERO


#move away from player
func _get_path_to_move_away_from_player() -> void:
	var dir: Vector2 = (global_position - player.position).normalized()
	nav_agent.target_position = global_position + dir * 100

