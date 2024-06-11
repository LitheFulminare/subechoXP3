extends Node

var current_room = 0 # 0 é o menu, as salas vâo de 1 a 10r
var current_scene = null

var tutorial_completed = false
var killed_last_boss_on_run = false

var shop_room = false
var shop_on_2 = false
var shop_on_6 = false

var tutorial = "res://Scenes/Layouts/Tutorial.tscn" # tutorial

var room_1 = "res://Scenes/Layouts/Fase 01.tscn" # 1
var room_2 = "res://Scenes/Layouts/Fase 02.tscn" # 2 

var ran_room_1 = "res://Scenes/Layouts/Fase Rand1.tscn" # 3
var ran_room_2 = "res://Scenes/Layouts/Fase Rand2.tscn" # 4 
var ran_room_3 = "res://Scenes/Layouts/Fase Rand3.tscn" # 5 
var ran_room_4 = "res://Scenes/Layouts/Fase Rand4.tscn" # 6
var ran_room_5 = "res://Scenes/Layouts/Fase Rand5.tscn" # 7

var boss_1 = "res://Scenes/Layouts/Boss 01.tscn" # 8
var final_boss = "res://Scenes/Layouts/Boss 02.tscn" # 9

var loja_mid = "res://Scenes/Layouts/LojaMidGame.tscn"

#region old room (discarded)

#const room_1 = "res://Scenes/Layouts/Main 1.tscn"
#endregion
#const room_2 = "res://Scenes/Layouts/Main 2.tscn"
#const room_3 = "res://Scenes/Layouts/Main 3.tscn"
#const room_4 = 
#const room_5 = 
#const room_6 = 
#const room_7 = 
#const room_8 = 
#const room_9 = 
#const room_10 = 

var room_list = [ran_room_1, ran_room_2, ran_room_3, ran_room_4, ran_room_5]

func _ready():
	var root = get_tree().root
	current_scene = root.get_child(root.get_child_count() - 1)

func next_room():
	if current_room < 10:
		
		if current_room == 0: # se for a primeira sala
			player_vars.current_life = player_vars.max_life
			player_vars.current_energy = player_vars.max_energy
			
			if !tutorial_completed:
				goto_scene(tutorial)
		
##region Store
#
		## tutorial is not completed, current_room won't change so it's 0
		#if current_room == 2:
			#var random_float = randf()
			#if random_float <= 0.5:
				#shop_room = false
				#shop_on_2 = false
			#else:
				#shop_room = true
				#shop_on_2 = true
		#elif current_room == 3 && !shop_on_2:
			#shop_room == true
#
		#elif current_room == 6:
			#var random_float = randf()
			#if random_float <= 0.5:
				#shop_room = false
				#shop_on_6 = false
			#else:
				#shop_room = true
				#shop_on_6 = true
		#elif current_room == 7 && !shop_on_6:
			#shop_room = true
		#elif current_room == 9:
			#shop_room = true
##endregion

		if !shop_room && tutorial_completed:
			current_room += 1
			
			if current_room == 1:
				goto_scene(room_1)
				
			elif current_room == 2:
				goto_scene(room_2)
				
			else:
				print("sala: " + str(room_list[current_room-3]))
				goto_scene(room_list[current_room-3])
			
		elif shop_room && tutorial_completed:
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
