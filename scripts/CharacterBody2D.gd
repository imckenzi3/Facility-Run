extends CharacterBody2D
class_name Character

#speed & jump
const speed = 450
const jump_power = -2200

#acceleration
const acc: int = 40
const friction = 60 
const FRICTION: float = 0.15 

#gravity - 20 gravity too low 40 too high
const gravity = 35

#jumping
const max_jumps = 2
var current_jumps = 1

##shovel - ref to node
#@onready var shovel: Node2D = get_node("Shovel")
#@onready var shovel_animation_player: AnimationPlayer = shovel.get_node("ShovelAnimationPlayer")

#stateMachine
@onready var state_machine: Node = get_node("FiniteStateMachine")

#move
var mov_direction: Vector2 = Vector2.ZERO

#animated_Sprite
@onready var animated_sprite: AnimatedSprite2D = get_node("AnimatedSprite2D")

#loop over and over
func _physics_process(delta):
	#var input_dir: Vector2 = input()
	velocity = lerp(velocity, Vector2.ZERO, FRICTION)
	#if we want player to move have to call accerlation, add friction, add player movement
	#if input_dir != Vector2.ZERO: 
		#accelerate(input_dir)
		##play animations here
		##play_animation()
	#else:
		#add_friction()
		##play idle animations here
		##play_animation()
	#player_movement()
	#jump()
	
	#shows what key pressing
	#print(input_dir)
	
	#var mouse_direction: Vector2 = (get_global_mouse_position() - global_position).normalized()
	##update the rotation of the shovel using the angle of the mouse direction
	#shovel.rotation = mouse_direction.angle()
	#if shovel.scale.y == 1 and mouse_direction.x < 0:
		#shovel.scale.y = -1
	#elif shovel.scale.y == -1 and mouse_direction.x > 0:
		#shovel.scale.y = 1
	#
	##check if attack is pressed and the attack animation is not playing
	#if Input.is_action_just_pressed("ui_attack") and not shovel_animation_player.is_playing():
		#print("Player attacked")
		#shovel_animation_player.play("attack")
		
##movement
#func input() -> Vector2:
	#var input_dir = Vector2.ZERO
	#
	##get input direction
	#input_dir.x = Input.get_axis("ui_left", "ui_right")
	#input_dir = input_dir.normalized()
	#return input_dir

func accelerate(direction):
	velocity = velocity.move_toward(speed * direction, acc)

func add_friction():
	velocity = velocity.move_toward(Vector2.ZERO, friction)
	
#func player_movement():
	#move_and_slide()
	
#jump
func jump():
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
		
	
#move
func move() -> void:
	mov_direction = mov_direction.normalized()
	velocity += mov_direction * acc
	velocity = velocity.limit_length(speed)

