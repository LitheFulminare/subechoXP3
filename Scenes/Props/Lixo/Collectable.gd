extends Area2D

@export var scrap_value : int

var player_in_area = false

func _ready():
	pass

func _process(delta):
	if Input.is_action_pressed("Interact"):
		if player_in_area == true:
			print("coletou")
			get_tree().call_group("player", "collect" , "metal")

func _on_area_entered(area):
	if area.is_in_group("player"):
		player_in_area = true
