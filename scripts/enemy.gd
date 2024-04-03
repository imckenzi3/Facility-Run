#@icon("res://Art/v1.1 dungeon crawler 16x16 pixel pack/enemies/goblin/goblin_idle_anim_f0.png") #icon 

extends Character #Character ref
class_name Enemy

#have to call "NavigationAgent2D/Player" to locate the player for enemy navigation
@onready var player: CharacterBody2D = get_tree().current_scene.get_node("Player") #ref to player node

@onready var path_timer: Timer = get_node("PathTimer") #ref to Pathtimer node

#@onready var navigation_agent: NavigationAgent2D = get_parent().get_node("NavigationAgent2D") #ref to navigation agent
#@onready var navigation_agent: NavigationAgent2D = get_node("/root/Game/Rooms") #ref to navigation agent

#grabs NavigationAgent2D - all enemies must have to track a player
@onready var nav_agent := $NavigationAgent2D as NavigationAgent2D

##tracking speed
const trackingSpeed = 55

func _ready() -> void:
	var __ = connect("tree_exited", Callable(get_parent(), "_on_enemy_killed")) #if I know god knows

#needs to be float?? NO IT DOES NOT need to be float
#fun chase(delta: float) -> void:
func chase(_delta: float) -> void:
	var dir = to_local(nav_agent.get_next_path_position()).normalized() #simple track player
	velocity = dir * trackingSpeed #simpole velocity
	
	#moves enemy towards player
	move_and_slide() #move player func
	
	#is enemy facing player
	#if not navigation_agent.is_target_reached():
		#var vector_to_next_point: Vector2 = navigation_agent.get_next_path_position() - global_position
		#move_direction = vector_to_next_point * speed
		#
		##change sprite based on player location
		#if vector_to_next_point.x > 0 and animated_sprite.flip_h:
			#animated_sprite.flip_h = false
		#elif vector_to_next_point.x < 0 and not animated_sprite.flip_h:
			#animated_sprite.flip_h = true

#chaned to -> void and added else
func _on_path_timer_timeout() -> void:
	#stop enemy movement after playerdeath
	if is_instance_valid(player):
		_get_path_to_player()
	else:
		path_timer.stop()
		move_direction = Vector2.ZERO

func _get_path_to_player() -> void:
	nav_agent.target_position = player.global_position

