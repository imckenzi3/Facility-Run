extends Weapon

const BULLET_SCENE: PackedScene = preload("res://weapons/fresh_bullet.tscn")

@export var smokeScene: PackedScene #smoke effect

var bullet_speed = 2000
var direction = Vector2.ZERO

func shoot(offset: int) -> void:
	var bullet: Area2D = BULLET_SCENE.instantiate()
	get_tree().current_scene.add_child(bullet)
	bullet.launch(global_position, Vector2.LEFT.rotated(deg_to_rad(rotation_degrees + offset)), 500)
	
	var smoke = smokeScene.instantiate() as GPUParticles2D
	get_parent().add_child(smoke)
	smoke.global_position = self.global_position
	
	
	
