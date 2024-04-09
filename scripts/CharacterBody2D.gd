extends CharacterBody2D
class_name Character

#player movement
const FRICTION: float = 0.15 
const acc: int = 40 #acceleration
@export var max_speed: int = 100 #max_speed

var move_direction: Vector2 = Vector2.ZERO
var veloctiy: Vector2 = Vector2.ZERO

#jump - no longer needed at this moment
const speed = 45
#const jump_power = -650 

const friction = 60 #friction

#jumping
const max_jumps = 2
var current_jumps = 1

#stateMachine
@onready var state_machine: Node = get_node("FiniteStateMachine")

#health
@export var hp: int = 2: set = set_hp
signal hp_changed(new_hp)

#animated_Sprite
@onready var animated_sprite: AnimatedSprite2D = get_node("AnimatedSprite2D")

#loop over and over
func _physics_process(_delta: float) -> void:
	move_and_slide()
	velocity = lerp(velocity, Vector2.ZERO, FRICTION)
	
#player movement
func move() -> void:
	move_direction = move_direction.normalized()
	velocity += move_direction * acc
	velocity = velocity.limit_length(max_speed)

	
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

func accelerate(direction):
	velocity = velocity.move_toward(speed * direction, acc)
	
func add_friction():
	velocity = velocity.move_toward(Vector2.ZERO, friction)

