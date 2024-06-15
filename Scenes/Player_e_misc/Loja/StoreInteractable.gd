extends StaticBody2D

@export_enum("Recuperar vida", "Recuperar energia", "powerup" ) var interact_type: String = ""
@export_enum("+ vida", "+ energia") var powerup_type : String = ""

#@export_range(0,1000) var value : int:
	#set(value): 
		#value = value
		#if $Base != null:
			#$Base. value = value
			
var value = 0

var player_in_area = false
var depleted = false

func _ready():
	$Light.visible = false
	if $Base != null:
		value = $Base.value

func _input(event):
	if Input.is_action_pressed("Interact") && player_in_area:
		interact()

func interact():
	if interact_type != "":
		if not depleted && player_vars.current_scrap >= value:
			depleted = true
			$Light.visible = false
			get_tree().call_group("player", "change_stat", "scrap", -value)
			get_tree().call_group("player", "regen", interact_type)
			if $Base != null:
				$Base.turn_off()
			
			if interact_type == "Recuperar energia":
				$Sprite.play("default") # fica travado no ultimo frame

	if powerup_type != "":
		if not depleted && player_vars.current_scrap >= value:
			depleted = true
			$Light.visible = false
			get_tree().call_group("player", "change_stat", "scrap", -value)
			if $Base != null:
				$Base.turn_off()
			
			match powerup_type:
				"+ vida":
					player_vars.max_life += 25
					get_tree().call_group("player", "change_stat", "life", 25)
				"+ energia":
					player_vars.max_energy += 30
					get_tree().call_group("player", "change_stat", "energy", 30)


func _on_buy_area_area_entered(area):
	if area.is_in_group("interact area") && !depleted:
		player_in_area = true
		$Light.visible = true


func _on_buy_area_area_exited(area):
	if area.is_in_group("interact area") && !depleted:
		player_in_area = false
		$Light.visible = false
