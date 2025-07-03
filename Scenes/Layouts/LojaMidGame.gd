extends Node2D

@export_group("Store Interactables")
@export var interactable1: StoreInteractable
@export var interactable2: StoreInteractable
@export var interactable3: StoreInteractable
@export var interactable4: StoreInteractable

@export_group("AudioStreamPlayer")
@export var buy1: AudioStreamPlayer
@export var buy2: AudioStreamPlayer
@export var buy3: AudioStreamPlayer
@export var buy4: AudioStreamPlayer

var buy_effects: Array[AudioStreamPlayer]
var buy_effect_index: int = 0

func _ready():
	Global.shop_room = false
	
	# DEBUG
	#player_vars.current_scrap = 300
	#MusicManager.transition_to_song(MusicManager.shop_song)
	
	buy_effects = [buy1, buy2, buy3, buy4]
	
	interactable1.player_interacted.connect(player_interacted)
	interactable2.player_interacted.connect(player_interacted)
	interactable3.player_interacted.connect(player_interacted)
	interactable4.player_interacted.connect(player_interacted)
	
	$CanvasGroup/CanvasModulate.visible = true
	$"CanvasGroup/Player/Energy timer".stop()
	$CanvasGroup/Player.life = player_vars.current_life
	$CanvasGroup/Player.energy = player_vars.current_energy
	$CanvasGroup/Player.scrap = player_vars.current_scrap

func _process(delta):
	pass

func player_interacted() -> void:
	if buy_effect_index == 4:
		return
		
	buy_effects[buy_effect_index].play()
	buy_effect_index += 1

func _on_exit_area_entered(area):
	if area.is_in_group("player"):
		Global.next_room()
