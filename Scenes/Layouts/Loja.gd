extends Control

var weapon_preview : int # a arma que o jogador vê
#var weapon_selected : int # a arma que o jogador tem selecionado

# boolean se o jogador tem a arma desbloqueada ou não
#var Peacemaker = false
#var Imperium = false
#var Killerbee = false

func _ready():
	
	if player_vars.weapon_type == "":  # se nenhuma arma tiver sido selecionada antes,
		weapon_preview = 1             # ele vai escolher a arma 1
		#weapon_selected = 1     
		player_vars.weapon_type = "Gen-EricV1"            
		player_vars.current_weapon = 1
		player_vars.preview = 1
	else:
		weapon_preview = player_vars.preview
		
	switch_weapon()

func _process(delta):
	# mostra qtd de scrap do player
	$"UI Scrap/Texto scrap".text = str(player_vars.current_scrap)

func _on_right_pressed():
	if weapon_preview < 4: # weapon_preview deve ser menor que o número de armas
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
	
	# troca as armas mostradas e determina se o jogador tem a arma ou não
	# tb atualiza as barras de status
	if weapon_preview == 1:
		$"MarginContainer/Sprite/Arma1/Sprites 1".visible = true
		$Selecionar.visible = true
		$Comprar.visible = false
		$"Damage bar".value = 50
		$"Fire rate bar".value = 25
		
	elif weapon_preview == 2:
		$"MarginContainer/Sprite/Arma1/Sprites 2".visible = true
		$Selecionar.visible = true
		$Comprar.visible = false
		$"Damage bar".value = 20
		$"Fire rate bar".value = 65
		
	elif weapon_preview == 3:
		$"MarginContainer/Sprite/Arma1/Sprites 3".visible = true
		if player_vars.Peacemaker == false:
			$Selecionar.visible = false
			$Comprar.visible = true
			$"Damage bar".value = 32
			$"Fire rate bar".value = 20
			
	elif weapon_preview == 4:
		$"MarginContainer/Sprite/Arma1/Sprites 4".visible = true
		if player_vars.Imperium == false:
			$Selecionar.visible = false
			$Comprar.visible = true
			$"Damage bar".value = 35
			$"Fire rate bar".value = 68


func _on_voltar_pressed():
	# volta pro menu
	Global.goto_scene("res://Scenes/Layouts/principal.tscn")


func _on_selecionar_pressed():
	
	# salva a arma selecionada e quando o jogador voltar pra loja, o preview vai ser essa arma
	# também testa se o jogador tem a arma
	if weapon_preview == 1:
		player_vars.weapon_type = "Gen-EricV1"
		player_vars.preview = 1
	elif weapon_preview == 2:
		player_vars.weapon_type = "Gen-EricV2"
		player_vars.preview = 2
	elif weapon_preview == 3 && player_vars.Peacemaker == true:
		player_vars.weapon_type = "Peacemaker"
		player_vars.preview = 3
	elif weapon_preview == 4 && player_vars.Imperium == true:
		player_vars.weapon_type = "Imperium"
		player_vars.preview = 4


func _on_comprar_pressed():
	if weapon_preview == 3 && player_vars.Peacemaker == false && player_vars.current_scrap >= 50:
		player_vars.current_scrap -= 50
		player_vars.Peacemaker = true
		$Selecionar.visible = true
		$Comprar.visible = false
		
	if weapon_preview == 4 && player_vars.Imperium == false && player_vars.current_scrap >= 100:
		player_vars.current_scrap -= 100
		player_vars.Imperium = true
		$Selecionar.visible = true
		$Comprar.visible = false
