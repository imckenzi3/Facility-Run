extends CharacterBody2D


#speed
const speed = 35

#var for player
@export var player: Node2D
@onready var nav_agent := $NavigationAgent2D as NavigationAgent2D

#needs to be float
func _physics_process(delta: float) -> void:
	#movement
	#direction based off navigation agent
	var dir = to_local(nav_agent.get_next_path_position()).normalized()
	velocity = dir * speed
	
	#moves enemy
	move_and_slide()
	
#make path
func makepath() -> void:
	nav_agent.target_position = player.global_position

func _on_timer_timeout():
	makepath()
	
