extends Node2D

var explosaoPath = preload("res://Scenes/Player_e_misc/Particulas e projéteis/explosao.tscn")

@export var inimigo_scene : PackedScene
var inimigos_mortos = 0
@export var meta_fase1 = 6
var gameover = false

func _ready():
	$CanvasGroup/CanvasModulate.visible = true
	$CanvasGroup/Player.position = $"Player Spawn".global_position
	
	if Global.current_room != 0:
		$CanvasGroup/Player.life = player_vars.current_life
		$CanvasGroup/Player.energy = player_vars.current_energy
		$CanvasGroup/Player.scrap = player_vars.current_scrap
	else:
		$CanvasGroup/Player.life = player_vars.max_life
		$CanvasGroup/Player.energy = player_vars.max_energy
		$CanvasGroup/Player.scrap = 0
	#$CanvasGroup/Coral/Sprite2D.modulate = Color(randf(),randf(),randf())
	#$CanvasGroup/Alga/Sprite2D.modulate = Color(randf(),randf(),randf())
	
	#randomize_plants()
	#randomize_props()

func _process(delta):
	
	$"UI/UI vida e energia/Texto Inimigos Mortos".text = str(inimigos_mortos) + "/" + str(meta_fase1)

	if Input.is_action_pressed("restart"):
		#if not gameover:
		game_over_no_life()
			#gameover = true
	
	if $CanvasGroup/Player.life <= 0:
		#if not gameover:
		game_over_no_life()
			#gameover = true
	if $CanvasGroup/Player.energy <= 0:
		#if not gameover:
		game_over_no_energy()
	
	if inimigos_mortos >= meta_fase1:
		meta_fase_batida()
	
func meta_fase_batida():
	$CanvasGroup/SaidaVerdeDesligada.visible = false
	$CanvasGroup/SaidaVerdeLigada.visible = true

func game_over_no_life():
	if !gameover:
		gameover = true
		var explosao = explosaoPath.instantiate()
		$CanvasGroup.add_child(explosao)
		explosao.position = $CanvasGroup/Player.global_position
		explosao.scale = explosao.scale * 1.5
		explosao.get_node("luz").energy = 1
		$CanvasGroup/Player.death_no_life()
		explosao.anim("default")
		await get_tree().create_timer(3).timeout
		Global.goto_scene("res://Scenes/Layouts/Death Screen.tscn")
	
func game_over_no_energy():
	if !gameover:
		gameover = true
		$CanvasGroup/Player.death_no_energy()
		await get_tree().create_timer(3).timeout
		Global.goto_scene("res://Scenes/Layouts/Death Screen.tscn")



func contador_morte_inimigo():
	inimigos_mortos += 1
	player_vars.enemies_killed += 1


func _on_area_2d_area_entered(area):
	if inimigos_mortos >= meta_fase1:
		if area.is_in_group("player"):
			#print("mudanca")
			Global.next_room()
			#Global.goto_scene("res://Scenes/Layouts/Main 2.tscn")
		
func randomize_plants():
	randomize()
	var node_count = $CanvasGroup/Plantas.get_child_count()
	for i in node_count:
		var RN = randf()
		var node = $CanvasGroup/Plantas.get_child(i)
		if RN > 0.5:
			node.queue_free()
			
func randomize_props():
	randomize()
	var node_count = $CanvasGroup/Props.get_child_count()
	for i in node_count:
		var RN = randf()
		var node = $CanvasGroup/Props.get_child(i)
		if RN > 0.5:
			node.queue_free()
		
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


func _on_spawn_2_inimigo_timeout():
	if inimigos_mortos < meta_fase1:
		randomize()
		var numero_nos = $Spawns.get_children()
		var local_aleatorio = numero_nos[randi()% numero_nos.size()]
		var inimigo = inimigo_scene.instantiate()
		inimigo.player = $CanvasGroup/Player/playerpos
		inimigo.position = local_aleatorio.position
		add_child(inimigo)
