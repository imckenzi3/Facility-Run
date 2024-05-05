extends CharacterBody2D

@onready var interaction_area: InteractionArea = $InteractionArea
@onready var sprite = $AnimatedSprite2D
@onready var speech_sound 

@onready var animation_player: AnimationPlayer = get_node("AnimationPlayer")

const lines: Array[String] = [ #dialog text
	"Hi, welcome to the facility",
	"Watch your step",
	"Press space to end this conversation"
]

func _ready():
	interaction_area.interact = Callable(self, "_on_interact")
	
	animation_player.play("idle") #play idle animation

func _on_interact():
	DialogManager.start_dialog(global_position, lines, speech_sound)
	sprite.flip_h = true if interaction_area.get_overlapping_bodies()[0].global_position.x < global_position.x else false
	await DialogManager.dialog_finished
