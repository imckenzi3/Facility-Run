@icon("res://assets/characters/icon.svg")

extends CharacterBody2D
class_name Character

const speed = 450
const jump_power = -1200

#acceleration
const acc = 40
const friction = 60

#gravity
const gravity = 100

#jumping
const max_jumps = 2
var current_jumps = 1

#shovel - ref to node
@onready var shovel: Node2D = get_node("Shovel")
@onready var shovel_hitbox: Area2D = get_node("Shovel/Node2D/Sprite2D/Hitbox")
@onready var shovel_animation_player: AnimationPlayer = shovel.get_node("ShovelAnimationPlayer")

@export var hp: int = 2
#take damage
#variable to change the state when the character takes damage
@onready var state_machine: Node = get_node("FiniteStateMachine")

#move
const FRICTION: float = 0.15


#loop over and over
func _physics_process(_delta: float) -> void:
	var input_dir: Vector2 = input()
	
	#for move
	velocity = lerp(velocity, Vector2.ZERO, FRICTION)
	
	#if we want player to move have to call accerlation, add friction, add player movement
	if input_dir != Vector2.ZERO: 
		accelerate(input_dir)
		
		#play animations here
		#play_animation()
	else:
		add_friction()
		#play idle animations here
		#play_animation()
	player_movement()
	jump()
	
	#shows what key pressing
	#print(input_dir)
	
	var mouse_direction: Vector2 = (get_global_mouse_position() - global_position).normalized()
	#update the rotation of the shovel using the angle of the mouse direction
	shovel.rotation = mouse_direction.angle()
	
	#after chaning the sword rotation, set the knockback direction of the 
	#hitbox with the mouse direction
	shovel_hitbox.knockback_direction = mouse_direction
	
	if shovel.scale.y == 1 and mouse_direction.x < 0:
		shovel.scale.y = -1
	elif shovel.scale.y == -1 and mouse_direction.x > 0:
		shovel.scale.y = 1
	
	#check if attack is pressed and the attack animation is not playing
	if Input.is_action_just_pressed("ui_attack") and not shovel_animation_player.is_playing():
		print("Player attacked")
		shovel_animation_player.play("attack")
	
func input() -> Vector2:
	var input_dir = Vector2.ZERO
	
	#get input direction
	input_dir.x = Input.get_axis("ui_left", "ui_right")
	input_dir = input_dir.normalized()
	return input_dir

func accelerate(direction):
	velocity = velocity.move_toward(speed * direction, acc)

func add_friction():
	velocity = velocity.move_toward(Vector2.ZERO, friction)
	
func player_movement():
	move_and_slide()
	
#jump
func jump():
#
	if Input.is_action_just_pressed("ui_up"):
	#check if current jumps is less than our max jumps
	#if we have jumped twice we do not want to jump again
		if current_jumps < max_jumps:
			velocity.y = jump_power
			current_jumps = current_jumps + 1
	else:
			#adding gravity
			velocity.y += gravity
			
		#hit the ground reset jumps
	if is_on_floor():
		current_jumps = 1

#Take Damage
func take_damage(dam: int, dir: Vector2, force: int) -> void:
	hp -= dam
	state_machine.set_state(state_machine.states.hurt)
	velocity += dir * force
	
	
#play animations
func play_animation():
	pass

#move
var mov_direction: Vector2 = Vector2.ZERO
func move() -> void:
	mov_direction = mov_direction.normalized()
	velocity += mov_direction * acc
	velocity = velocity.limit_length(speed)

