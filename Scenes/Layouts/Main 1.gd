extends Node2D

func _ready():
	pass 



func _process(delta):
	
	$UI/Integridade.text = "Integridade: " + str($CanvasGroup/Player.life)
	$UI/Energia.text = "Energia: " + str($CanvasGroup/Player.energy)
	
	if $CanvasGroup/Player.life <= 0 || $CanvasGroup/Player.energy <= 0 :
		game_over()
		

func game_over():
	await get_tree().create_timer(3).timeout
	get_tree().reload_current_scene()
