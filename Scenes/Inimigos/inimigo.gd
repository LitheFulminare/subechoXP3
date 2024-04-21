extends CharacterBody2D

@export var speed = 50
@export var nav_agent: NavigationAgent2D
@export var vida = 5
@export var dano = 5

var target_node = null
var home_pos = Vector2.ZERO

const tiro1 = preload("res://Scenes/Player_e_misc/Particulas e projéteis/Tiro 1.tscn")

func _ready():
	$Sprite.play("default")
	
	home_pos = self.global_position
	nav_agent.path_desired_distance = 4
	nav_agent.target_desired_distance = 4

func _physics_process(delta):
	if nav_agent.is_navigation_finished():
		return
	
	var axis = to_local(nav_agent.get_next_path_position()).normalized()
	velocity = axis * speed
	
	move_and_slide()
	
	
func _process(delta):
	if vida <= 0:
		queue_free()


func _on_area_2d_area_entered(area):
	if area.is_in_group("tiro"):
		var danoRec = area.get_parent().dano
		print("tipo")
		danoTiro(danoRec)
		
func danoTiro(danoRec):
	vida -= danoRec
	
func recalc_path():
	if target_node:
		nav_agent.target_position = target_node.global_position
	else:
		nav_agent.target_position = home_pos

func _on_navigation_agent_2d_velocity_computed(safe_velocity):
	pass # Replace with function body.


func _on_timer_recalcular_timeout():
	recalc_path()


func _on_aggro_range_area_entered(area):
	if area.is_in_group("player"):
		target_node = area.owner

func _on_de_aggro_range_area_exited(area):
	if area.owner == target_node:
		target_node == null
