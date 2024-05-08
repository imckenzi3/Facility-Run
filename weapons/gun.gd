extends Weapon

const BULLET_SCENE: PackedScene = preload("res://weapons/fresh_bullet.tscn")

@export var smokeScene: PackedScene #smoke effect

#recoil
@export var max_recoil := 10.0
var current_recoil := 0.0 #not exported internal var used to track 0 to max recoil at any given time

var bullet_speed = 2000
var direction = Vector2.ZERO
	
func shoot(offset: int) -> void:
	
	var dir_to_mouse = (get_global_mouse_position() - global_position).normalized() #direction to mouse
	var bullet: Area2D = BULLET_SCENE.instantiate()
	get_tree().current_scene.add_child(bullet)

	
	#when gun shoots add recoil
	var recoil_degree_max = current_recoil * 0.5
	var recoil_radians_actual = deg_to_rad(randf_range(-recoil_degree_max, recoil_degree_max))
	var actual_bullet_direction = dir_to_mouse.rotated(recoil_radians_actual) #rotat
	
	var recoil_increment = max_recoil * 0.1
	current_recoil = clamp(current_recoil + recoil_increment, 0.0, max_recoil)
		#apply recoild to direction of mouse
		
	bullet.launch(global_position, Vector2.LEFT.rotated(deg_to_rad(rotation_degrees + offset)), 500)
	
	#when gun shoots add smokes effect
	var smoke = smokeScene.instantiate() as GPUParticles2D
	get_parent().add_child(smoke)
	smoke.global_position = self.global_position
	#smoke.rotation = smoke.normal.angle()
	
	
