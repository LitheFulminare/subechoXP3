extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	$"Texto Scrap".text = "Sucata coletada: " + str(player_vars.scrap_gained)
	$"Texto Inimigos mortos".text = "Inimigos mortos: " + str(player_vars.enemies_killed)
	
	player_vars.scrap_gained = 0
	player_vars.enemies_killed = 0


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _input(event):
	if Input.is_anything_pressed():
		Global.goto_scene("res://Scenes/Layouts/principal.tscn")
