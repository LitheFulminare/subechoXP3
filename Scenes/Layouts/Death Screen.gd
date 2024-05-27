extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	$"Texto Scrap".text = "Sucata coletada: " + str(player_vars.scrap_gained)
	player_vars.scrap_gained = 0


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _input(event):
	if Input.is_anything_pressed():
		Global.goto_scene("res://Scenes/Layouts/principal.tscn")
