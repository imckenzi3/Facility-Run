extends CharacterBody2D
#class_name Character, "res://cow.png"

const speed = 550
const jump_power = -2000

#acceleration
const acc = 50
const friction = 70

#gravity
const gravity = 120

#jumping
const max_jumps = 2
var current_jumps = 1

#loop over and over
func _physics_process(delta):
	var input_dir: Vector2 = input()
	
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

		
	
#play animations
func play_animation():
	pass

