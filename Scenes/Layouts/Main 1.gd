extends Node2D

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	$UI/Integridade.text = "Integridade: " + str($CanvasGroup/Player.life)
	$UI/Energia.text = "Energia: " + str($CanvasGroup/Player.energy)
	
	if $CanvasGroup/Player.life <= 0 || $CanvasGroup/Player.energy <= 0 :
		game_over()

func game_over():	
	await get_tree().create_timer(1).timeout
	get_tree().reload_current_scene()

