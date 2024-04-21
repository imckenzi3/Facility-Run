@icon("res://weapons/weapon_crowbar.png") #icon 
extends Node2D
class_name Weapon

@onready var animation_player: AnimationPlayer = get_node("ShovelAnimationPlayer")
@onready var charge_particles: GPUParticles2D = get_node("Node2D/Sprite2D/ChargeParticles2D")
@onready var hitxbox: Area2D = get_node("Node2D/Sprite2D/Hitbox")

func get_input() -> void:
		#check if attack is pressed and the attack animation is not playing
	if Input.is_action_just_pressed("ui_attack") and not animation_player.is_playing():
		animation_player.play("charge")
	elif Input.is_action_just_released("ui_attack"):
		if animation_player.is_playing() and animation_player.current_animation == "charge":
			animation_player.play("attack")
		elif charge_particles.emitting:
			animation_player.play("charge_attack")
			
func move(mouse_direction: Vector2) -> void:
	if not animation_player.is_playing() or animation_player.current_animation == "charge":
		#update the rotation of the shovel using the angle of the mouse direction
		rotation = mouse_direction.angle()
		#set the knockback direction of the hitbox with the mouse direction
		hitxbox.knockback_direction = mouse_direction # doesnt even work - theres no knock back in dark souls anyawys
			
		if scale.y == 1 and mouse_direction.x < 0:
			scale.y = -1
		elif scale.y == -1 and mouse_direction.x > 0:
			scale.y = 1

func cancel_attack() -> void:
	animation_player.play("RESET")

func is_busy() -> bool:
	if animation_player.is_playing() or charge_particles.emitting:
		return true
	return false
