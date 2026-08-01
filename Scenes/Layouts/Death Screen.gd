extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	if Global.killed_last_boss_on_run:
		print("Play good song here")
		$"Label morte".text = "Vitória"
		$"Texto morte".text = "Vitória"
	else: 
		MusicManager.play_music(MusicManager.SONGS.At_the_bottom_of_the_sea)
		$"Label morte".text = "Você morreu"
		$"Texto morte".text = "Você morreu"
	$"Texto Scrap".text = "Sucata coletada: " + str(player_vars.scrap_gained)
	$"Texto Inimigos mortos".text = "Inimigos mortos: " + str(player_vars.enemies_killed)
	$"Texto scrap gasta".text = "Sucata gasta: " + str(player_vars.scrap_spent)
	$"Texto sala alcançada".text = "Sala alcançada: " + str(Global.current_room)
	
	player_vars.scrap_gained = 0
	player_vars.enemies_killed = 0


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_continuar_pressed():
	Global.goto_scene("res://Scenes/Layouts/principal.tscn")
