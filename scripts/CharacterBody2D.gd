extends CharacterBody2D
class_name Character

#speed & jump
const speed = 450
const jump_power = -600

#acceleration
const acc: int = 40
const friction = 60 
const FRICTION: float = 0.15 

#gravity - 20 gravity too low 40 too high
const gravity = 35

#jumping
const max_jumps = 2
var current_jumps = 1

##shovel - ref to node - enemies cant have main weapon on all enemys so we have to call in Player script
#@onready var shovel: Node2D = get_node("Shovel")
#@onready var shovel_animation_player: AnimationPlayer = shovel.get_node("ShovelAnimationPlayer")

#stateMachine
@onready var state_machine: Node = get_node("FiniteStateMachine")

#health
@export var hp: int = 2

#enemy tracking movement
var mov_direction: Vector2 = Vector2.ZERO

#animated_Sprite
@onready var animated_sprite: AnimatedSprite2D = get_node("AnimatedSprite2D")

#loop over and over
func _physics_process(delta):
	velocity = lerp(velocity, Vector2.ZERO, FRICTION)
		
	#player_movement() # cant here call will move enemies
	
	#jump() # cant here call jump here - no gravity
	
	
func accelerate(direction):
	velocity = velocity.move_toward(speed * direction, acc)
	
func add_friction():
	velocity = velocity.move_toward(Vector2.ZERO, friction)
	
#Basic Enemy Tracking
func move() -> void:
	mov_direction = mov_direction.normalized()
	velocity += mov_direction * acc
	velocity = velocity.limit_length(speed)
	
#Taking Damage
func take_damage(dam: int, dir: Vector2, force: int) -> void:
	hp -= dam
	state_machine.set_state(state_machine.states.hurt)
	velocity += dir * force
