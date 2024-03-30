#extends Character
#class_name Enemy
#
#@onready var player: CharacterBody2D = get_tree().current_scene.get_node("Player")
#@onready var path_timer: Timer = get_node("PathTimer")
#@onready var navigation_agent: NavigationAgent2D = get_node("NavigationAgent2D")
#
#
#func _ready() -> void:
	#var __ = connect("tree_exited", Callable(get_parent(), "_on_enemy_killed"))
#
#
#func chase() -> void:
	#if not navigation_agent.is_target_reached():
		#var vector_to_next_point: Vector2 = navigation_agent.get_next_path_position() - global_position
		#mov_direction = vector_to_next_point
#
		##if vector_to_next_point.x > 0 and animated_sprite.flip_h:
			##animated_sprite.flip_h = false
		##elif vector_to_next_point.x < 0 and not animated_sprite.flip_h:
			##animated_sprite.flip_h = true
#
#
#func _on_PathTimer_timeout() -> void:
	#if is_instance_valid(player):
		#_get_path_to_player()
	#else:
		#path_timer.stop()
		#mov_direction = Vector2.ZERO
#
#
#func _get_path_to_player() -> void:
	#navigation_agent.target_position = player.position


#old code - works
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
	#hurt
	#_add_state("hurt")
	
#make path
func makepath() -> void:
	nav_agent.target_position = player.global_position

func _on_timer_timeout():
	makepath()
	
	
