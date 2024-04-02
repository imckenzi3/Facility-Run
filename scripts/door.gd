extends StaticBody2D

@onready var animation_player: AnimationPlayer = get_node("AnimationPlayer") #stores the animationPlayer Node

func open() -> void:
	animation_player.play("open")
