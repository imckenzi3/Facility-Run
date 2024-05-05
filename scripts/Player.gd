@icon("res://assets/characters/Test_Dummy/Test_Dummy_Right.png") #icon 
extends Character

const DUST_SCENE: PackedScene = preload("res://characters/player/dust.tscn")
enum {UP, DOWN} #weapon switch

signal weapon_switched(prev_index, new_index)
signal weapon_picked_up(weapon_texture)
signal weapon_droped(index)

#Weapons
#var current_weapon: Weapon 
@onready var current_weapon: Node2D = $Weapons/sycth
#var current_weapon: Node2D

@onready var parent: Node2D = get_parent()
@onready var weapons: Node2D = get_node("Weapons")

#Dust effect
@onready var dust_position: Node2D = get_node("DustPosition")

func _ready() -> void:
	emit_signal("weapon_picked_up", weapons.get_child(0).get_texture())
	#current_weapon = weapons.get_child(0).get_texture()

	_restore_previous_state()
	
func _restore_previous_state() -> void:
	print(SavedData.weapons) 
	self.hp = SavedData.hp
	for weapon in SavedData.weapons:
		weapon = weapon.duplicate()
		weapon.position = Vector2.ZERO
		weapons.add_child(weapon)
		weapon.hide()

		emit_signal("weapon_picked_up", weapon.get_texture())
		emit_signal("weapon_switched", weapons.get_child_count() - 2, weapons.get_child_count() - 1)

	current_weapon = weapons.get_child(SavedData.equipped_weapon_index)
	current_weapon.show()

	emit_signal("weapon_switched", weapons.get_child_count() - 1, SavedData.equipped_weapon_index)

func _process(_delta: float) -> void:
	if DialogManager.is_dialog_active:
		return
		
	#movement - current main working player movement
	var input_dir: Vector2 = input()
	if input_dir != Vector2.ZERO: 
		accelerate(input_dir)
	else:
		add_friction()
		
	input() #player movement
	
	var mouse_direction: Vector2 = (get_global_mouse_position() - global_position).normalized()	#mouse direction
		
	if input_dir.x > 0 and animated_sprite.flip_h:
		animated_sprite.flip_h = false
	elif input_dir.x < 0 and not animated_sprite.flip_h:
		animated_sprite.flip_h = true
	
	#weapon position around player
	current_weapon.move(mouse_direction)
	
	
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
	
	if not current_weapon.is_busy(): #changes 
		if Input.is_action_just_released("ui_previous_weapon"):
			_switch_weapon(UP)
		elif Input.is_action_just_released("ui_next_weapon"):
				_switch_weapon(DOWN)
		elif Input.is_action_just_pressed("ui_throw") and current_weapon.get_index() != 0:
			_drop_weapon()

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
	SavedData.equipped_weapon_index = index #saves current weapon for next level
	
	emit_signal("weapon_switched", prev_index, index)

#weapon pickup
func pick_up_weapon(weapon: Node2D) -> void:
	SavedData.weapons.append(weapon.duplicate())
	var prev_index: int = SavedData.equipped_weapon_index
	var new_index: int = weapons.get_child_count()
	SavedData.equipped_weapon_index = new_index
	weapon.get_parent().call_deferred("remove_child", weapon)
	weapons.call_deferred("add_child", weapon)
	weapon.set_deferred("owner", weapons)
	current_weapon.hide()
	current_weapon.cancel_attack()
	current_weapon = weapon

	emit_signal("weapon_picked_up", weapon.get_texture())
	emit_signal("weapon_switched", prev_index, new_index)

#drops weapon
func _drop_weapon() -> void:
	SavedData.weapons.remove_at(current_weapon.get_index() - 1)
	var weapon_to_drop: Node2D = current_weapon
	_switch_weapon(UP)

	emit_signal("weapon_droped", weapon_to_drop.get_index())

	weapons.call_deferred("remove_child", weapon_to_drop)
	get_parent().call_deferred("add_child", weapon_to_drop)
	weapon_to_drop.set_owner(get_parent())
	await weapon_to_drop.tree_entered
	weapon_to_drop.show()
	var throw_dir: Vector2 = (get_global_mouse_position() - position).normalized()
	weapon_to_drop.interpolate_pos(position, position + throw_dir * 50)
	
#cancel attack
func cancel_attack() -> void:
	current_weapon.cancel_attack()

#walking dust effect
func spawn_dust() ->void:
	var dust: Sprite2D = DUST_SCENE.instantiate()
	dust.position = dust_position.global_position
	parent.get_child(get_index() - 1).add_sibling(dust)
	
	
#move camera in the main scene to player position, make current and deactivate the real cam
func switch_camera() -> void:
	var main_scene_camera: Camera2D = get_parent().get_node("Camera2D")
	main_scene_camera.position = position
	main_scene_camera.current = true
	get_node("Camera2D").current = false

func take_damage(dam: int, dir: Vector2, force: int) -> void:
	if state_machine.state != state_machine.states.hurt and state_machine.state != state_machine.states.dead:
		
		_spawn_hit_effect() #hit effect
		self.hp -= dam #subtracte hp based on damage
		frameFreeze(0.1, 0.4) #free frame (time scale, duration)
		#save hp for next level
		if name == "player":
				SavedData.hp = hp
				if hp == 0:
					SceneTransistor.start_transition_to("res://scenes/game.tscn")
					SavedData.reset_data()
					
		DamageNumbers.display_number(dam, damage_number_origin.global_position) #display damage numbers
		#var is_critical self.crit_chance > randf()
		
		#if after taking damage the hp is greater than 0
		#set the state to hurt and apply a normal knockback (theres no knockbacks in darksouls) are there?
		#!!!knock back doesnt work - fix later if we want it
		
		#player damaged here
		if hp > 0:
			state_machine.set_state(state_machine.states.hurt)
			velocity += dir * force
			#print("player hit")
		else:
			state_machine.set_state(state_machine.states.dead)
			velocity += dir * force * 2
			
			#player death here
			#print("player died")
			#Kill()
	
#players color
func set_color(color_name, color):
	match color_name:
		"Primary":
			%Primary.self_modulate = color
		"Secondary":
			%Secondary.self_modulate = color
		"Outline":
			%Outline.self_modulate = color
#
