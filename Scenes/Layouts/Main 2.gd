extends Node2D

var explosaoPath = preload("res://Scenes/Player_e_misc/Particulas e projéteis/explosao.tscn")
#var fase2 = preload("res://Scenes/Layouts/Main 2.tscn")

@export var inimigo_scene : PackedScene
var inimigos_mortos = 0
var meta_fase2 = 10
var gameover = false

func _ready():
	$CanvasGroup/Player.life = player_vars.current_life
	$CanvasGroup/Player.energy = player_vars.current_energy
	$CanvasGroup/Player.scrap = player_vars.current_scrap
	
	#$CanvasGroup/Player.position = $"Player Spawn".global_position
	#$CanvasGroup/Player/Camera2D.position = $"Player Spawn".global_position
	pass

func _process(delta):
	
	if $CanvasGroup/Player.life >= 0:
		$"UI/UI vida e energia/Texto Vida".text = str($CanvasGroup/Player.life)
	else: 
		$"UI/UI vida e energia/Texto Vida".text = "0"
	
	if $"CanvasGroup/Player".energy >= 0:
		$"UI/UI vida e energia/Texto Energia".text = str($CanvasGroup/Player.energy)
	else: 
		$"UI/UI vida e energia/Texto Energia".text = "0"
	
	$"UI/UI vida e energia/Texto Inimigos Mortos".text = str(inimigos_mortos) + "/5"
	
	$"UI/UI vida e energia/Texto scrap".text = str($CanvasGroup/Player.scrap)

	if Input.is_action_pressed("restart"):
		game_over_no_life()
		
	if $CanvasGroup/Player.life <= 0: #|| $CanvasGroup/Player.energy <= 0:
		if not gameover:
			game_over_no_life()
			gameover = true
	if $CanvasGroup/Player.energy <= 0:
		if not gameover:
			game_over_no_energy()
	
	#if inimigos_mortos >= meta_fase1:
		#meta_fase_batida()
		
func meta_fase_batida():
	pass
	#$CanvasGroup/SaidaVerdeDesligada.visible = false
	#$CanvasGroup/SaidaVerdeLigada.visible = true

func game_over_no_life():
	var explosao = explosaoPath.instantiate()
	$CanvasGroup.add_child(explosao)
	explosao.position = $CanvasGroup/Player.global_position
	explosao.scale = explosao.scale * 1.5
	$CanvasGroup/Player.death_no_life()
	explosao.anim("default")
	await get_tree().create_timer(3).timeout
	Global.goto_scene("res://Scenes/Layouts/principal.tscn")
	
func game_over_no_energy():
	$CanvasGroup/Player.death_no_energy()
	await get_tree().create_timer(3).timeout
	Global.goto_scene("res://Scenes/Layouts/principal.tscn")



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
	#get_tree().change_scene_to_file("res://Scenes/Layouts/principal.tscn")
	Global.goto_scene("res://Scenes/Layouts/principal.tscn")
