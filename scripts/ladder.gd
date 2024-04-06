extends Area2D
class_name Ladder #class name to detect ladder and not another world element inside of the game

func _on_body_entered(player):
	if player.is_in_group("Climber"):
		if player.climbing == false:
			player.climbing = true
	pass

func _on_body_exited(player):
	if player.is_in_group("Climber"):
		if player.climbing == true:
			player.climbing = false
	pass # Replace with function body.
