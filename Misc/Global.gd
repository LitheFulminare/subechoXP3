extends Node

var current_room = 0 # 0 é o menu, as salas vâo de 1 a 10r
var current_scene = null

var killed_last_boss_on_run = false

const room_1 = "res://Scenes/Layouts/Main 1.tscn"
const room_2 = "res://Scenes/Layouts/Main 2.tscn"
const room_3 = "res://Scenes/Layouts/Main 3.tscn"
#const room_4 = 
#const room_5 = 
#const room_6 = 
#const room_7 = 
#const room_8 = 
#const room_9 = 
#const room_10 = 

var room_list = [room_1, room_2, room_3] #, room_4, room_5, room_6, room_7, room_8, room_9, room_10]

func _ready():
	var root = get_tree().root
	current_scene = root.get_child(root.get_child_count() - 1)

func next_room():
	if current_room < 10:
		current_room += 1
		print("sala: " + str(room_list[current_room-1]))
		goto_scene(room_list[current_room-1])
	if current_room == 10:
		goto_scene("res://Scenes/Layouts/Death Screen.tscn")

func goto_scene(path):

	call_deferred("_deferred_goto_scene", path)
	
func _deferred_goto_scene(path):
	# It is now safe to remove the current scene.
	
	current_scene.queue_free()
	
	# Load the new scene.
	var s = ResourceLoader.load(path)

	# Instance the new scene.
	current_scene = s.instantiate()

	# Add it to the active scene, as child of root.
	get_tree().root.add_child(current_scene)

	# Optionally, to make it compatible with the SceneTree.change_scene_to_file() API.
	#get_tree().current_scene = current_scene
