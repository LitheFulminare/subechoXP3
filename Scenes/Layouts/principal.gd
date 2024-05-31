extends Control

func ready():
	pass
	
func _process(delta):
	pass

func _on_play_pressed():
	Global.goto_scene("res://Scenes/Layouts/Main 1.tscn")


func _on_exit_pressed():
	get_tree().quit()


func _on_loja_pressed():
	Global.goto_scene("res://Scenes/Layouts/Loja.tscn")


func _on_credits_pressed():
	Global.goto_scene("res://Scenes/Layouts/creditos.tscn")
