@icon("res://assets/characters/Test_Dummy/Test_Dummy_Right.png") #icon 
extends Character

#shovel - ref to node
@onready var shovel: Node2D = get_node("Shovel")
@onready var shovel_animation_player: AnimationPlayer = shovel.get_node("ShovelAnimationPlayer")

#shovel - ref to hitbox
@onready var shovel_hitbox: Area2D = get_node("Shovel/Node2D/Sprite2D/Hitbox")

#@onready var ladderCheck = $LadderCheck
#@export var climbing = false

func _physics_process(_delta: float) -> void:
	#if is_on_ladder(): #works!!! yay
		#print("on ladder")

	#movement - current main working player movement
	var input_dir: Vector2 = input()
	if input_dir != Vector2.ZERO: 
		accelerate(input_dir)
		#play animations here
		#play_animation()
	else:
		add_friction()
		#play idle animations here
		#play_animation()
	input() #player movement
		#
	##jump()
		
	#mouse direction
	var mouse_direction: Vector2 = (get_global_mouse_position() - global_position).normalized()

	if mouse_direction.x > 0 and animated_sprite.flip_h:
		animated_sprite.flip_h = false
	elif mouse_direction.x < 0 and not animated_sprite.flip_h:
		animated_sprite.flip_h = true
			
	#update the rotation of the shovel using the angle of the mouse direction
	shovel.rotation = mouse_direction.angle()
	#set the knockback direction of the hitbox with the mouse direction
	shovel_hitbox.knockback_direction = mouse_direction # doesnt even work - theres no knock back in dark souls anyawys
		
	if shovel.scale.y == 1 and mouse_direction.x < 0:
		shovel.scale.y = -1
	elif shovel.scale.y == -1 and mouse_direction.x > 0:
		shovel.scale.y = 1
		
	#check if attack is pressed and the attack animation is not playing
	if Input.is_action_just_pressed("ui_attack") and not shovel_animation_player.is_playing():
		print("Player attacked")
		shovel_animation_player.play("attack")

func player_movement():
	move_and_slide()
	
#movement
func input() -> Vector2:
	var input_dir = Vector2.ZERO
	#get input direction
	#input_dir.x = Input.get_axis("ui_left", "ui_right")
	#input_dir = input_dir.normalized()
	
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


