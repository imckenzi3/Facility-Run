@icon("res://assets/characters/Test_Dummy/Test_Dummy_Right.png") #icon 
extends Character

enum {UP, DOWN} #weapon switch

signal weapon_switched(prev_index, new_index)
signal weapon_picked_up(weapon_texture)
signal weapon_droped(index)

#Weapons
#var current_weapon: Weapon 
@onready var current_weapon: Node2D = $Weapons/crowbar

@onready var parent: Node2D = get_parent()
@onready var weapons: Node2D = get_node("Weapons")

	
func ready() -> void:
	current_weapon = weapons.get_child(0).get_texture()

#shovel - ref to node
#@onready var shovel: Node2D = get_node("Shovel")
#@onready var shovel_animation_player: AnimationPlayer = shovel.get_node("ShovelAnimationPlayer")
#
##shovel - ref to hitbox
#@onready var shovel_hitbox: Area2D = get_node("Shovel/Node2D/Sprite2D/Hitbox")
#@onready var charge_particle: GPUParticles2D = get_node("Shovel/Node2D/Sprite2D/ChargeParticles2D")

#ladder crap
#@onready var ladderCheck = $LadderCheck
#@export var climbing = false

func _process(_delta: float) -> void:
	#if is_on_ladder(): #works!!! yay
		#print("on ladder")

	#movement - current main working player movement
	var input_dir: Vector2 = input()
	if input_dir != Vector2.ZERO: 
		accelerate(input_dir)
	else:
		add_friction()
		
	input() #player movement
	var mouse_direction: Vector2 = (get_global_mouse_position() - global_position).normalized()	#mouse direction

	#if mouse_direction.x > 0 and animated_sprite.flip_h:
		#animated_sprite.flip_h = false
	#elif mouse_direction.x < 0 and not animated_sprite.flip_h:
		#animated_sprite.flip_h = true
		
	if input_dir.x > 0 and animated_sprite.flip_h:
		animated_sprite.flip_h = false
	elif input_dir.x < 0 and not animated_sprite.flip_h:
		animated_sprite.flip_h = true
		
	current_weapon.move(mouse_direction)
	
	##update the rotation of the shovel using the angle of the mouse direction
	#shovel.rotation = mouse_direction.angle()
	##set the knockback direction of the hitbox with the mouse direction
	#shovel_hitbox.knockback_direction = mouse_direction # doesnt even work - theres no knock back in dark souls anyawys
		#
	#if shovel.scale.y == 1 and mouse_direction.x < 0:
		#shovel.scale.y = -1
	#elif shovel.scale.y == -1 and mouse_direction.x > 0:
		#shovel.scale.y = 1
	#
	#check if attack is pressed and the attack animation is not playing
	#if Input.is_action_just_pressed("ui_attack") and not shovel_animation_player.is_playing():
		#shovel_animation_player.play("charge")
	#elif Input.is_action_just_released("ui_attack"):
		#if shovel_animation_player.is_playing() and shovel_animation_player.current_animation == "charge":
			#shovel_animation_player.play("attack")
		#elif charge_particle.emitting:
			#shovel_animation_player.play("charge_attack")
	
func player_movement():
	move_and_slide()
	
#movement
func input() -> Vector2:
	var input_dir = Vector2.ZERO
	#get input direction
	#input_dir.x = Input.get_axis("ui_left", "ui_right")
	#input_dir = input_dir.normalized()
	
	#movement
	input_dir = Vector2.ZERO
	input_dir.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	input_dir.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	
	return input_dir
	
func get_input() -> void:    
	move_direction = Vector2.ZERO
		
	if Input.is_action_pressed("ui_down"):
		move_direction += Vector2.DOWN
	if Input.is_action_pressed("ui_left"):
		move_direction += Vector2.LEFT
	if Input.is_action_pressed("ui_right"):
		move_direction += Vector2.RIGHT
	if Input.is_action_pressed("ui_up"):
		move_direction += Vector2.UP
		

	if not current_weapon.is_busy():
		if Input.is_action_just_released("ui_previous_weapon"):
			_switch_weapon(UP)
		elif Input.is_action_just_released("ui_next_weapon"):
				_switch_weapon(DOWN)

	current_weapon.get_input()

#change weapons
func _switch_weapon(direction: int) -> void:
	var prev_index: int = current_weapon.get_index()
	var index: int = current_weapon.get_index()
	if direction == UP:
		index -= 1
		if index < 0:
			index = weapons.get_child_count() - 1
	else:
		index += 1
		if index > weapons.get_child_count() - 1:
			index = 0
	
	current_weapon.hide()
	current_weapon = weapons.get_child(index)
	current_weapon.show()
	
	emit_signal("weapon_switched", prev_index, index)


func pick_up_weapon(weapon: Node2D) -> void:
	weapon.get_parent().call_deferred("remove_child", weapon)
	weapons.call_deferred("add_child", weapon)
	weapon.set_deferred("owner", weapons)
	current_weapon.hide()
	current_weapon.cancel_attack()
	current_weapon = weapon

	#emit_signal("weapon_picked_up", weapon.get_texture())
	#emit_signal("weapon_switched", prev_index, new_index)

	
func cancel_attack() -> void:
	current_weapon.cancel_attack()
	
#move camera in the main scene to player position, make current and deactivate the real cam
func switch_camera() -> void:
	var main_scene_camera: Camera2D = get_parent().get_node("Camera2D")
	main_scene_camera.position = position
	main_scene_camera.current = true
	get_node("Camera2D").current = false


#no longer needed if player not jumping
#func jump():
	#if Input.is_action_just_pressed("ui_up"):
	##check if current jumps is less than our max jumps
	##if we have jumped twice we do not want to jump again
		#if current_jumps < max_jumps:
			#velocity.y = jump_power
			#current_jumps = current_jumps + 1
	#else:
			##adding gravity
			#velocity.y += gravity
			#
			##setting velocity to zero makes player idle animation work
			#
		##hit the ground reset jumps
	#if is_on_floor():
		#current_jumps = 1

#func is_on_ladder():
	#if not ladderCheck.is_colliding(): return false
	#var collider = ladderCheck.get_collider()
	#if not collider is Ladder: return false
	#return true
	#
#func climb_state():
	#if not is_on_ladder(): state = move()
	#velocity = speed * 50
	#veloctity = move_and_slide()


