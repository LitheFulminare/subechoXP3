extends Control

var weapon_preview : int
var weapon_selected : int

func _ready():
	
	if player_vars.current_weapon == null:
		weapon_preview = 1
		player_vars.current_weapon = 1
	else:
		weapon_preview = player_vars.current_weapon
		
	if weapon_preview == 1:
		$"MarginContainer/Sprite/Arma1/Sprites 1".visible = true
	elif weapon_preview == 2:
		$"MarginContainer/Sprite/Arma1/Sprites 2".visible = true
	elif weapon_preview == 3:
		$"MarginContainer/Sprite/Arma1/Sprites 3".visible = true
	elif weapon_preview == 4:
		$"MarginContainer/Sprite/Arma1/Sprites 4".visible = true
		#switch_weapon()
		
	
#func _process(delta):
	
	
	#if weapon_selected == 1:
		#$"MarginContainer/Sprite/Arma1/Sprites 1".visible = true
	#elif weapon_selected == 2:
		#$"MarginContainer/Sprite/Arma1/Sprites 2".visible = true
	#elif weapon_selected == 3:
		#$"MarginContainer/Sprite/Arma1/Sprites 3".visible = true
	#elif weapon_selected == 4:
		#$"MarginContainer/Sprite/Arma1/Sprites 4".visible = true
	

func _on_right_pressed():
	if weapon_preview < 4:
		$MarginContainer/Sprite/Arma1.get_child(weapon_preview-1).visible = false
		weapon_preview += 1
		switch_weapon()


func _on_left_pressed():
	if weapon_preview > 1:
		$MarginContainer/Sprite/Arma1.get_child(weapon_preview-1).visible = false
		weapon_preview -= 1
		switch_weapon()
		
func switch_weapon():
	if weapon_preview == 1:
		$"MarginContainer/Sprite/Arma1/Sprites 1".visible = true
	elif weapon_preview == 2:
		$"MarginContainer/Sprite/Arma1/Sprites 2".visible = true
	elif weapon_preview == 3:
		$"MarginContainer/Sprite/Arma1/Sprites 3".visible = true
	elif weapon_preview == 4:
		$"MarginContainer/Sprite/Arma1/Sprites 4".visible = true


func _on_voltar_pressed():
	player_vars.current_weapon = weapon_preview # trocar isso pela arma selecionada
	Global.goto_scene("res://Scenes/Layouts/principal.tscn")
