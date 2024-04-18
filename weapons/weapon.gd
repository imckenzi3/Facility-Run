@icon("res://weapons/weapon_crowbar.png") #icon 
extends Node2D
class_name Weapon

@onready var animation_player: AnimationPlayer = get_node("AnimationPlayer")
#@onready var charge_particles: CPUParticles2D = get_node("AnimationPlayer")
@onready var hitxbox: Area2D = get_node("Node2D/Sprite2D/Hitbox")


func move(mouse_direction: Vector2) -> void:
	if not animation_player.is_playing() 
	rotation = mouse_direction.angle()
	#set the knockback direction of the hitbox with the mouse direction
	hitxbox.knockback_direction = mouse_direction #
	
	if scale.y == 1 and mouse_direction.x < 0:
		scale.y = -1
	elif scale.y == -1 and mouse_direction.x > 0:
		scale.y = 1

