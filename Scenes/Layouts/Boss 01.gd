extends Node2D

var explosaoPath = preload("res://Scenes/Player_e_misc/Particulas e projéteis/explosao.tscn")
#var fase2 = preload("res://Scenes/Layouts/Main 2.tscn")

@export var inimigo_scene : PackedScene
var inimigos_mortos = 0
@export var meta_fase = 6
var gameover = false
var boss_dead = false

func _ready():
	Global.boss_room = false
	$UI.visible = true
	$CanvasGroup/CanvasModulate.visible = true
	$CanvasGroup/Player.global_position = $"Player Spawn".global_position
	
	if Global.current_room != 0:
		$CanvasGroup/Player.life = player_vars.current_life
		$CanvasGroup/Player.energy = player_vars.current_energy
		$CanvasGroup/Player.scrap = player_vars.current_scrap
	else:
		$CanvasGroup/Player.life = player_vars.max_life
		$CanvasGroup/Player.energy = player_vars.max_energy
		$CanvasGroup/Player.scrap = 0
		
	#$CanvasGroup/Player.position = $"Player Spawn".global_position
	#$CanvasGroup/Player/Camera2D.position = $"Player Spawn".global_position
	pass

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
	
	$"UI/UI vida e energia/Texto Inimigos Mortos".text = str(inimigos_mortos) + "/" + str(meta_fase)
	
	#$"UI/UI vida e energia/Texto scrap".text = str($CanvasGroup/Player.scrap)

	if Input.is_action_pressed("restart"):
		game_over_no_life()
		
	if $CanvasGroup/Player.life <= 0: #|| $CanvasGroup/Player.energy <= 0:
		if not gameover:
			game_over_no_life()
			gameover = true
	if $CanvasGroup/Player.energy <= 0:
		if not gameover:
			game_over_no_energy()
	
	if $CanvasGroup/Boss1.life <= 0:
		boss_dead = true
		$CanvasGroup/SaidaVerdeDesligada.visible = false
		$CanvasGroup/SaidaVerdeLigada.visible = true
	
	#if inimigos_mortos >= meta_fase:
		#meta_fase_batida()
		
#func meta_fase_batida():
	#$CanvasGroup/SaidaVerdeDesligada.visible = false
	#$CanvasGroup/SaidaVerdeLigada.visible = true

func game_over_no_life():
	if !gameover:
		gameover = true
		var explosao = explosaoPath.instantiate()
		$CanvasGroup.add_child(explosao)
		explosao.position = $CanvasGroup/Player.global_position
		explosao.scale = explosao.scale * 1.5
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



#func contador_morte_inimigo():
	#inimigos_mortos += 1
	#player_vars.enemies_killed += 1


func _on_area_2d_area_entered(area):
	if boss_dead:
		if area.is_in_group("player"):
			Global.next_room()

#func _on_spawn_2_inimigo_timeout():
	#if inimigos_mortos < meta_fase:
		#randomize()
		#var numero_nos = $Spawns.get_children()
		#var local_aleatorio = numero_nos[randi()% numero_nos.size()]
		#var inimigo = inimigo_scene.instantiate()
		#inimigo.player = $CanvasGroup/Player/playerpos
		#inimigo.position = local_aleatorio.position
		#add_child(inimigo)

func restart():
	Global.goto_scene("res://Scenes/Layouts/principal.tscn")
