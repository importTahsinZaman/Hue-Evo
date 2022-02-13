extends AnimatedSprite

func _ready():
	var size = rand_range(2.5, 3.2)
	scale = Vector2(size, size)

func _on_Explostion_animation_finished():
	queue_free()
