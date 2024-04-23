extends Control

var level1 = preload("res://Scenes/Layouts/Main 1.tscn")
var level2 = preload("res://Scenes/Layouts/Main 2.tscn")
var debug = preload("res://Scenes/Layouts/debug.tscn")

func ready():
	pass
	
func _process(delta):
	if Input.is_action_pressed("Iniciar"):
		Iniciar()
	

func Iniciar():
	get_tree().change_scene_to_packed(level1)
	
func ir_para_fase_2():
	pass
	#get_tree().change_scene_to_packed(debug)


func _on_play_pressed():
	Global.goto_scene("res://Scenes/Layouts/Main 1.tscn")


func _on_exit_pressed():
	get_tree().quit()
