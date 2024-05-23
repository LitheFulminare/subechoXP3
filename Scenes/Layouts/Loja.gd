extends Control

var weapon_preview : int # a arma que o jogador vê

# descrição de cada arma e o path do arquivo delas
@onready var desc_arma_1 = "res://Misc/Textos/Desc arma 1.txt"
@onready var desc_arma_2 = "res://Misc/Textos/Desc arma 2.txt"
@onready var desc_arma_3 = "res://Misc/Textos/Desc arma 3.txt"
@onready var desc_arma_4 = "res://Misc/Textos/Desc arma 4.txt"
@onready var desc_arma_5 = "res://Misc/Textos/Desc arma 5.txt"

func _ready():
	#desc_arma_1 = "res://Misc/Textos/Desc arma 1.txt"
	#desc_arma_2 = "res://Misc/Textos/Desc arma 2.txt"
	#desc_arma_3 = "res://Misc/Textos/Desc arma 3.txt"
	#desc_arma_4 = "res://Misc/Textos/Desc arma 4.txt"
	
	
	if player_vars.weapon_type == "":  # se nenhuma arma tiver sido selecionada antes,
		weapon_preview = 1             # ele vai escolher a arma 1
		
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
	if weapon_preview < 5: # weapon_preview deve ser menor que o número de armas para poder passar
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
	match weapon_preview:
	# troca as armas mostradas e determina se o jogador tem a arma ou não
	# tb atualiza as barras de status
		1:
			$"text x3".visible = false
			$"MarginContainer/Sprite/Arma1/Sprites 1".visible = true
			$Selecionar.visible = true
			$Comprar.visible = false
			$"Damage bar".value = 50
			$"Fire rate bar".value = 25
			$"Precision bar".value = 68
			$MarginContainer/Sprite/Arma1.modulate = Color(1, 1, 1, 1)
			$"MarginContainer3/Nome da arma".text = "Gen-EricV1"
			$"MarginContainer2/Descrição".text = FileAccess.open(desc_arma_1,FileAccess.READ).get_as_text()
		
		2:
			$"text x3".visible = false
			$"MarginContainer/Sprite/Arma1/Sprites 2".visible = true
			$Selecionar.visible = true
			$Comprar.visible = false
			$"Damage bar".value = 20
			$"Fire rate bar".value = 55
			$"Precision bar".value = 40
			$MarginContainer/Sprite/Arma1.modulate = Color(1, 1, 1, 1)
			$"MarginContainer3/Nome da arma".text = "Gen-EricV2"
			$"MarginContainer2/Descrição".text =FileAccess.open(desc_arma_2,FileAccess.READ).get_as_text()
		
		3:
			$"text x3".visible = true
			$"MarginContainer/Sprite/Arma1/Sprites 3".visible = true
			$"Damage bar".value = 32
			$"Fire rate bar".value = 20
			$"Precision bar".value = 25
			$"MarginContainer3/Nome da arma".text = "Peacemaker"
			$"MarginContainer2/Descrição".text = FileAccess.open(desc_arma_3,FileAccess.READ).get_as_text()
			if player_vars.Peacemaker == false:
				$Selecionar.visible = false
				$Comprar.visible = true
				$MarginContainer/Sprite/Arma1.modulate = Color(0.65, 0.65, 0.65, 0.65)
				
			else:
				$Selecionar.visible = true
				$Comprar.visible = false
				$MarginContainer/Sprite/Arma1.modulate = Color(1, 1, 1, 1)
			
		4:
			$"text x3".visible = false
			$"MarginContainer/Sprite/Arma1/Sprites 4".visible = true
			$"Damage bar".value = 35
			$"Fire rate bar".value = 68
			$"Precision bar".value = 55
			$"MarginContainer3/Nome da arma".text = "Imperium"
			$"MarginContainer2/Descrição".text = FileAccess.open(desc_arma_4,FileAccess.READ).get_as_text()
			if player_vars.Imperium == false:
				$Selecionar.visible = false
				$Comprar.visible = true
				$MarginContainer/Sprite/Arma1.modulate = Color(0.65, 0.65, 0.65, 0.65)
			else:
				$Selecionar.visible = true
				$Comprar.visible = false
				$MarginContainer/Sprite/Arma1.modulate = Color(1, 1, 1, 1)
		5:
			$"text x3".visible = false
			$"MarginContainer/Sprite/Arma1/Sprites 5".visible = true
			$"Damage bar".value = 75
			$"Fire rate bar".value = 20
			$"Precision bar".value = 80
			$"MarginContainer3/Nome da arma".text = "Killerbee"
			$"MarginContainer2/Descrição".text = FileAccess.open(desc_arma_5,FileAccess.READ).get_as_text()
			if player_vars.Killerbee == false:
				$Selecionar.visible = false
				$Comprar.visible = true
				$MarginContainer/Sprite/Arma1.modulate = Color(0.65, 0.65, 0.65, 0.65)
			else:
				$Selecionar.visible = true
				$Comprar.visible = false
				$MarginContainer/Sprite/Arma1.modulate = Color(1, 1, 1, 1)


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
	elif weapon_preview == 5 && player_vars.Killerbee == true:
		player_vars.weapon_type = "Killerbee"
		player_vars.preview = 5


func _on_comprar_pressed():
	if weapon_preview == 3 && player_vars.Peacemaker == false && player_vars.current_scrap >= 50:
		player_vars.Peacemaker = true
		player_vars.current_scrap -= 50
		switch_weapon()
		
	if weapon_preview == 4 && player_vars.Imperium == false && player_vars.current_scrap >= 100:
		player_vars.Imperium = true
		player_vars.current_scrap -= 100
		switch_weapon()
		
	if weapon_preview == 5 && player_vars.Killerbee == false && player_vars.current_scrap >= 200:
		player_vars.Killerbee = true
		player_vars.current_scrap -= 200
		switch_weapon()
