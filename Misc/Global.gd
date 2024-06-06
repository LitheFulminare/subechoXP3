extends Node

var current_room = 0 # 0 é o menu, as salas vâo de 1 a 10r
var current_scene = null

var killed_last_boss_on_run = false

var shop_room = false
var shop_on_2 = false
var shop_on_6 = false

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
		
		if current_room == 0: # se for a primeira sala
			player_vars.current_life = player_vars.max_life
			player_vars.current_energy = player_vars.max_energy
		
		if current_room == 2:
			var random_float = randf()
			if random_float <= 0.5:
				shop_room = false
				shop_on_2 = false
			else:
				shop_room = true
				shop_on_2 = true
		elif current_room == 3 && !shop_on_2:
			shop_room == true

		elif current_room == 6:
			var random_float = randf()
			if random_float <= 0.5:
				shop_room = false
				shop_on_6 = false
			else:
				shop_room = true
				shop_on_6 = true
		elif current_room == 7 && !shop_on_6:
			shop_room = true
		elif current_room == 9:
			shop_room = true

		if !shop_room:
			current_room += 1
			print("sala: " + str(room_list[current_room-1]))
			goto_scene(room_list[current_room-1])
		else:
			shop_room = false
			print("sala atual é a loja. a variavel current_room é " + str(current_room))
			goto_scene("res://Scenes/Layouts/LojaMidGame.tscn")

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
