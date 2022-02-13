extends KinematicBody2D

var health = 5

const Explosion = preload("res://Scenes/Explosion.tscn")

func _physics_process(delta):
	if health <= 0:
		get_parent().get_node("MainCamera").shake(600, 0.5, 600)
		queue_free()
		var explosion = Explosion.instance()
		explosion.global_position = global_position
		get_tree().root.add_child(explosion)

func play_hit_animation():
	$AnimationPlayer.play("hit_animation")
