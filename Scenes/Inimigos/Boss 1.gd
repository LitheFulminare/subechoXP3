extends CharacterBody2D


@export var player:= Node2D
@onready var nav_agent := $NavigationAgent2D as NavigationAgent2D

@export var vida = 50
@export var dano = 5
@export var speed = 80

@onready var animation_tree : AnimationTree = $AnimationTree

func makepath() -> void:
	nav_agent.target_position = player.global_position


func _on_timer_timeout():
	makepath()
