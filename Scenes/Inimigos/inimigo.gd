extends CharacterBody2D

@export var vida = 5
@export var dano = 5

const tiro1 = preload("res://Scenes/Player_e_misc/Particulas e projéteis/Tiro 1.tscn")

func _ready():
	$Sprite.play("default")
	
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
