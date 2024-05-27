extends Node2D

var explosaoPath = preload("res://Scenes/Player_e_misc/Particulas e projéteis/explosao.tscn")
#var fase2 = preload("res://Scenes/Layouts/Main 2.tscn")

@export var inimigo_scene : PackedScene
var inimigos_mortos = 0
var meta_fase1 = 5
var gameover = false

func _ready():
	$CanvasGroup/Player.position = $"Player Spawn".global_position
	#$CanvasGroup/Coral/Sprite2D.modulate = Color(randf(),randf(),randf())
	#$CanvasGroup/Alga/Sprite2D.modulate = Color(randf(),randf(),randf())
	#$CanvasGroup/Alga2/Sprite2D.modulate = Color(randf(),randf(),randf())
	#$CanvasGroup/Alga3/Sprite2D.modulate = Color(randf(),randf(),randf())

func _process(delta):
	
	#if $CanvasGroup/Player.life >= 0:
		#$"UI/UI vida e energia/Texto Vida".text = str($CanvasGroup/Player.life)
	#else: 
		#$"UI/UI vida e energia/Texto Vida".text = "0"
	#
	#if $"CanvasGroup/Player".energy >= 0:
		#$"UI/UI vida e energia/Texto Energia".text = str($CanvasGroup/Player.energy)
	#else: 
		#$"UI/UI vida e energia/Texto Energia".text = "0"
	
	$"UI/UI vida e energia/Texto Inimigos Mortos".text = str(inimigos_mortos) + "/5"
	
	#if $CanvasGroup/Player.scrap > 0:
	#$"UI/UI Scrap/Texto scrap".text = str($CanvasGroup/Player.scrap)
	#else: $"UI/UI Scrap".text = "0"
	
	
	if Input.is_action_pressed("restart"):
		if not gameover:
			game_over_no_life()
			gameover = true
		#restart()
	
	if $CanvasGroup/Player.life <= 0: #|| $CanvasGroup/Player.energy <= 0:
		if not gameover:
			game_over_no_life()
			gameover = true
	if $CanvasGroup/Player.energy <= 0:
		if not gameover:
			game_over_no_energy()
	
	if inimigos_mortos >= meta_fase1:
		meta_fase_batida()
		
	
	
func meta_fase_batida():
	$CanvasGroup/SaidaVerdeDesligada.visible = false
	$CanvasGroup/SaidaVerdeLigada.visible = true

func game_over_no_life():
	var explosao = explosaoPath.instantiate()
	$CanvasGroup.add_child(explosao)
	explosao.position = $CanvasGroup/Player.global_position
	explosao.scale = explosao.scale * 1.5
	$CanvasGroup/Player.death_no_life()
	explosao.anim("default")
	await get_tree().create_timer(3).timeout
	Global.goto_scene("res://Scenes/Layouts/Death Screen.tscn")
	
func game_over_no_energy():
	$CanvasGroup/Player.death_no_energy()
	await get_tree().create_timer(3).timeout
	Global.goto_scene("res://Scenes/Layouts/Death Screen.tscn")



func contador_morte_inimigo():
	inimigos_mortos += 1
	player_vars.enemies_killed += 1


func _on_area_2d_area_entered(area):
	if inimigos_mortos >= meta_fase1:
		if area.is_in_group("player"):
			print("mudanca")
			Global.goto_scene("res://Scenes/Layouts/Main 2.tscn")
	#get_tree().call_group("logica", "ir_para_fase_2")


func _on_spawn_inimigo_timeout():
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
	Global.goto_scene("res://Scenes/Layouts/principal.tscn")

func _on_barril_explosivo_explosao_barril(global_position):
	var explosao = explosaoPath.instantiate()
	$CanvasGroup.add_child(explosao)
	explosao.position = global_position
	explosao.anim("default")


func _on_player_died_by_explosion():
	if not gameover:
		game_over_no_life()
		gameover = true
