extends Control

var weapon_preview : int # a arma que o jogador vê
var weapon_selected : int # a arma que o jogador tem selecionado

func _ready():
	
	if player_vars.current_weapon == null:  # se nenhuma arma tiver sido selecionada antes,
		weapon_preview = 1                  # ele vai escolher a arma 1
		weapon_selected = 1                
		player_vars.current_weapon = 1
	else:
		weapon_preview = player_vars.current_weapon
		
	switch_weapon()


func _on_right_pressed():
	if weapon_preview < 4:
		# esconde a sprite atual, muda a var do preview e chama a função que relaliza a troca de arma
		$MarginContainer/Sprite/Arma1.get_child(weapon_preview-1).visible = false
		weapon_preview += 1
		switch_weapon()


func _on_left_pressed():
	if weapon_preview > 1:
		# esconde a sprite atual, muda a var do preview e chama a função que relaliza a troca de arma
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


func _on_voltar_pressed(): # mudar para weapon selected
	if weapon_preview == 1:
		player_vars.weapon_type = "Gen-EricV1"
	elif weapon_preview == 2:
		player_vars.weapon_type = "Gen-EricV2"
	elif weapon_preview == 3:
		player_vars.weapon_type = "Peacemaker"
	elif weapon_preview == 4:
		player_vars.weapon_type = "Imperium"

	player_vars.current_weapon = weapon_preview # trocar isso pela arma selecionada
	Global.goto_scene("res://Scenes/Layouts/principal.tscn")
