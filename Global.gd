extends Node

var current_player = true #true = player1 , false = player2

var max_player_health = 10
var player1_health = 10
var player2_health = 10

func _physics_process(delta):
	if Input.is_action_just_pressed("switch_player"):
		current_player = !current_player
