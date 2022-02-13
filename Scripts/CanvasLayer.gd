extends CanvasLayer


func _ready():
	$ProgressBar.max_value = Global.max_player_health
	$ProgressBar2.max_value = Global.max_player_health
	
func _physics_process(delta):
	$ProgressBar.value = Global.player1_health
	$ProgressBar2.value = Global.player2_health
