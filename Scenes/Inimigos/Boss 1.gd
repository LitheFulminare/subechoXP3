extends CharacterBody2D

@export var player:= Node2D
@onready var nav_agent := $NavigationAgent2D as NavigationAgent2D

@export var vida = 50
@export var dano = 5
@export var speed = 80

@onready var animation_tree : AnimationTree = $AnimationTree

var player_close = false

func _ready():
	animation_tree.active = true
	
	
func _process(delta):
	update_animation_parameters()

func _physics_process(_delta: float) -> void:
	var dir = to_local(nav_agent.get_next_path_position()).normalized()
	velocity = dir * speed
	
	move_and_slide()

func makepath() -> void:
	nav_agent.target_position = player.global_position


func _on_timer_timeout():
	pass
	#makepath()
	
func update_animation_parameters():
	pass


func _on_melee_trigger_area_entered(area):
	if area.is_in_group("player"):
		player_close = true


func _on_melee_trigger_area_exited(area):
	if area.is_in_group("player"):
		player_close = false
