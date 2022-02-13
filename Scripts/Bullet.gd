extends RigidBody2D

var speed = -350
onready var y_pos = global_position.y 

func _physics_process(delta):
	apply_impulse(Vector2(), Vector2(speed , 0).rotated(rotation))
	global_position.y = y_pos


func _on_VisibilityNotifier2D_screen_exited():
	queue_free()

