extends StaticBody2D

@export_enum("Recuperar vida", "Recuperar energia", "powerup" ) var interact_type: String


@export_enum("Nenhum") var powerup_type : String = "Nenhum"

var player_in_area = false
var depleted = false

func _ready():
	$Light.visible = false

func _input(event):
	if Input.is_action_pressed("Interact") && player_in_area:
		interact()

func interact():
	if not depleted && player_vars.current_scrap >= 70:
		depleted = true
		get_tree().call_group("player", "change_stat", "scrap", -70)
		get_tree().call_group("player", "regen", interact_type)
		
		if interact_type == "Recuperar energia":
			$Sprite.play("default") # fica travado no ultimo frame


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
		$Light.visible = true


func _on_buy_area_area_exited(area):
	if area.is_in_group("player"):
		player_in_area = false
		$Light.visible = false
