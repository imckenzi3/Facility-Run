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
@export var hp: int = 2: set = set_hp
signal hp_changed(new_hp)

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
	self.hp -= dam
	
	#if after taking damage the hp is greater than 0
	#set the state to hurt and apply a normal knockback (theres no knockbacks in darksouls) are there?
	#!!!knock back doesnt work - fix later if we want it
	if hp > 0:
		state_machine.set_state(state_machine.states.hurt)
		velocity += dir * force
	else:
		state_machine.set_state(state_machine.states.dead)
		velocity += dir * force * 2
		
#called every time we modify the value of the hp variable
func set_hp(new_hp: int) -> void:
	hp = new_hp
	emit_signal("hp_changed", new_hp)
	#update the hp variable and emit the isgnal hp_changed with new_hp as parameter.
