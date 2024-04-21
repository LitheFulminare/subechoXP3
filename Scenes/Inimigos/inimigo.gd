extends CharacterBody2D

var speed = 100

@export var player:= Node2D
@onready var nav_agent := $NavigationAgent2D as NavigationAgent2D
@export var vida = 5
@export var dano = 5

#const tiro1 = preload("res://Scenes/Player_e_misc/Particulas e projéteis/Tiro 1.tscn")

func _ready():
	$Sprite.play("default")
	
func _physics_process(_delta: float) -> void:
	var dir = to_local(nav_agent.get_next_path_position()).normalized()
	velocity = dir * speed
	
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
	
func makepath() -> void:
	nav_agent.target_position = player.global_position


func _on_timer_timeout():
	makepath()
