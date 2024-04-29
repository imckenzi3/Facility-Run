@icon("res://weapons/hmag1n.png") #icon 
extends Node2D
class_name Weapon

@export var on_floor: bool = false

var tween: Tween = null

@onready var animation_player: AnimationPlayer = get_node("ShovelAnimationPlayer")
@onready var charge_particles: GPUParticles2D = get_node("Node2D/Sprite2D/ChargeParticles2D")
@onready var hitbox: Area2D = get_node("Node2D/Sprite2D/Hitbox")
#@onready var player_detector: Area2D = get_node("PlayerDetector")
@onready var player_detector: Area2D = $PlayerDetector
@export var rotation_offset: int = 0
 
func _ready() -> void:
	if not on_floor:
		player_detector.set_collision_mask_value(1, false)
		player_detector.set_collision_mask_value(2, false)

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
		#rotation = rad_to_deg(mouse_direction.angle()) + rotation_offset
		rotation = mouse_direction.angle()
		#	rotation = mouse_direction.angle()
		#rad_to_deg(mouse_direction.angle()) + rotation_offset
		#set the knockback direction of the hitbox with the mouse direction
		hitbox.knockback_direction = mouse_direction # doesnt even work - theres no knock back in dark souls anyawys
			
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

func get_texture() -> Texture2D:
	return get_node("Node2D/Sprite2D").texture

func _on_player_detector_body_entered(body: CharacterBody2D) -> void:
	if body != null:
		player_detector.set_collision_mask_value(1, false)
		player_detector.set_collision_mask_value(2, false)
		body.pick_up_weapon(self)
		position = Vector2.ZERO
	else:
		if tween:
			tween.kill()
		player_detector.set_collision_mask_value(2, true)

func interpolate_pos(initial_pos: Vector2, final_pos: Vector2) -> void:
	position = initial_pos
	tween = create_tween()
	tween.tween_property(self, "position", final_pos, 0.8).set_trans(Tween.TRANS_QUART).set_ease(Tween.EASE_OUT)
	tween.connect("finished", _on_Tween_tween_completed)
	player_detector.set_collision_mask_value(1, true)

func _on_Tween_tween_completed() -> void:
	player_detector.set_collision_mask_value(2, true)