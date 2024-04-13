extends ProgressBar

@onready var timer: Timer = get_node("HealthTimer") #ref to navigation node
@onready var health_bar: ProgressBar = get_node("HealthBar") #ref to navigation node

@onready var parentHp: Character = get_parent() # ref to hp

#var hp already called in character from enemy
func _set_health(new_health):
	var prev_health = 	parentHp.hp
	parentHp.hp = min(max_value, new_health)
	value = parentHp.hp
	
	if parentHp.hp <= 0:
		queue_free()
		
	if parentHp.hp < prev_health:
		timer.start()
	else:
		health_bar.value = parentHp.hp
	
func init_health(_health):
	parentHp.hp = _health
	max_value = parentHp.hp
	value = parentHp.hp
	health_bar.max_value = parentHp.hp
	health_bar.value = parentHp.hp

func _on_health_timer_timeout():
	health_bar.value = parentHp.hp
