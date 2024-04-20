extends Node2D

@export var inimigo_scene : PackedScene

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


func _on_spawn_inimigo_timeout():
	var inimigo = inimigo_scene.instantiate()
	inimigo.position = $Marker2D.position
	add_child(inimigo)
