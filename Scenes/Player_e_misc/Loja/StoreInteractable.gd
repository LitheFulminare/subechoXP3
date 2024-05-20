extends StaticBody2D

@export_enum("Recuperar vida", "Recuperar energia", "powerup" ) var interact_type: String = "Recuperar vida"

@export_enum("Nenhum") var powerup_type : String = "Nenhum"

var player_in_area = false
var depleted = false

func _input(event):
	if Input.is_action_pressed("Interact") && player_in_area:
		interact()

func interact():
	if not depleted:
		depleted = true
		get_tree().call_group("player", "regen", interact_type)


	#match interact_type:
		#"Recuperar vida":
			##get_tree().call_group("player", "regen", interact_type)
			#player_vars.current_life = player_vars.max_life
		#"Recuperar energia":
			##get_tree().call_group("player", "regen", interact_type)
			#player_vars.current_energy = player_vars.max_energy


func _on_buy_area_area_entered(area):
	if area.is_in_group("player"):
		player_in_area = true


func _on_buy_area_area_exited(area):
	if area.is_in_group("player"):
		player_in_area = false
