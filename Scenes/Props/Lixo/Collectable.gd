extends Area2D

@export_enum("plastic", "bottle", "fish", "metal") var type: String
@export var scrap_value : int

var player_in_area = false

func _ready():
	pass

func _process(delta):
	if Input.is_action_just_pressed("Interact"):
		if player_in_area == true:
			#print("coletou")
			get_tree().call_group("player", "collect" , type)
			get_parent().queue_free()

func _on_area_entered(area):
	if area.is_in_group("player"):
		player_in_area = true
		print("debug entrou")
	

func _on_area_exited(area):
	if area.is_in_group("player"):
		player_in_area = false
