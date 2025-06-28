extends Control

func _ready():
	MusicManager.play_main_theme()
	
	Global.killed_last_boss_on_run = false
	Global.current_room = 0
	
func _process(delta):
	pass

func _on_play_pressed():
	Global.room_list.shuffle()
	MusicManager.stop_playing_with_fadeout(3)
	MusicManager.queued_song = MusicManager.play_level_1
	Global.next_room()
	#print(Global.room_list)
	#Global.goto_scene("res://Scenes/Layouts/Main 1.tscn")


func _on_exit_pressed():
	get_tree().quit()


func _on_loja_pressed():
	Global.goto_scene("res://Scenes/Layouts/Loja.tscn")


func _on_credits_pressed():
	Global.goto_scene("res://Scenes/Layouts/creditos.tscn")
