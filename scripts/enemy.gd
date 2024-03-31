#@icon("res://Art/v1.1 dungeon crawler 16x16 pixel pack/enemies/goblin/goblin_idle_anim_f0.png") #icon 

extends Character #Character ref
class_name Enemy

#have to call "NavigationAgent2D/Player" to locate the player for enemy navigation
@onready var player: CharacterBody2D = get_tree().current_scene.get_node("NavigationAgent2D/Player") #ref to player node

@onready var path_timer: Timer = get_node("PathTimer") #ref to Pathtimer node

@onready var navigation_agent: NavigationAgent2D = get_node("NavigationAgent2D") #ref to navigation agent

#tracking speed
const trackingSpeed = 55

func _ready() -> void:
	var __ = connect("tree_exited", Callable(get_parent(), "_on_enemy_killed")) #if I know god knows

#needs to be float?? NO IT DOES NOT need to be float
#fun chase(delta: float) -> void:
func chase() -> void:
	var dir = to_local(navigation_agent.get_next_path_position()).normalized() #simple track player
	velocity = dir * trackingSpeed #simpole velocity
	
	##moves enemy
	move_and_slide() #move player func
	
	#change sprite based on player location
	if dir.x > 0 and animated_sprite.flip_h:
		animated_sprite.flip_h = false
	elif dir.x < 0 and not animated_sprite.flip_h:
		animated_sprite.flip_h = true

func makepath() -> void:
	navigation_agent.target_position = player.global_position

func _on_path_timer_timeout():
	makepath()
	#if is_instance_valid(player):
		#_get_path_to_player()
	#else:
		#path_timer.stop()
		#mov_direction = Vector2.ZERO


