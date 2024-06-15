extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	$CanvasGroup/CanvasModulate.visible = true
	$"CanvasGroup/Player/Energy timer".stop()
	$CanvasGroup/Player.life = player_vars.current_life
	$CanvasGroup/Player.energy = player_vars.current_energy
	$CanvasGroup/Player.scrap = player_vars.current_scrap


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_exit_area_entered(area):
	if area.is_in_group("player"):
		Global.next_room()
