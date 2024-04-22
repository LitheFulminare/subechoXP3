extends Node2D

#var fase2 = preload("res://Scenes/Layouts/Main 2.tscn")

@export var inimigo_scene : PackedScene
var inimigos_mortos = 0
var meta_fase2 = 5

func _ready():
	pass

func _process(delta):
	
	$UI/Integridade.text = "Integridade: " + str($CanvasGroup/Player.life)
	$UI/Energia.text = "Energia: " + str($CanvasGroup/Player.energy)
	$"UI/Inimigos mortos".text = "inimigos mortos: " + str(inimigos_mortos)

	if Input.is_action_pressed("restart"):
		restart()
		
	if $CanvasGroup/Player.life <= 0 || $CanvasGroup/Player.energy <= 0:
		game_over()
	
	#if inimigos_mortos >= meta_fase1:
		#meta_fase_batida()
		
func meta_fase_batida():
	pass
	#$CanvasGroup/SaidaVerdeDesligada.visible = false
	#$CanvasGroup/SaidaVerdeLigada.visible = true

func game_over():
	await get_tree().create_timer(3).timeout
	restart()
	#get_tree().reload_current_scene()



func contador_morte_inimigo():
	inimigos_mortos += 1


func _on_area_2d_area_entered(area):
	pass
	#if inimigos_mortos >= meta_fase2:
		#if area.is_in_group("player"):
			#print("mudanca")
			#get_tree().change_scene_to_file("res://Scenes/Layouts/Main 2.tscn")

func _on_spawn_2_inimigo_timeout():
	if inimigos_mortos < 5:
		randomize()
		var numero_nos = $Spawns.get_children()
		var local_aleatorio = numero_nos[randi()% numero_nos.size()]
		var inimigo = inimigo_scene.instantiate()
		inimigo.player = $CanvasGroup/Player/playerpos
		#inimigo.position = $"Spawns/spawn inimigo local 2".global_position
		inimigo.position = local_aleatorio.position
		add_child(inimigo)

func restart():
	get_tree().change_scene_to_file("res://Scenes/Layouts/principal.tscn")
