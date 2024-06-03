extends AnimatedSprite2D

func _ready() -> void:
	play("default")


func _on_animation_changed() -> void:
	self.queue_free() #when animation stops playing - free the scene
