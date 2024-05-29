extends Node2D

@export var pos := Node2D

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

	
func _process(delta):
	global_position = pos.global_position

	
func anim():

	$animacao.play()
	var tween = create_tween()
	tween.tween_property($luz, "scale", Vector2.ZERO, 1)
	tween.parallel().tween_property($luz, "energy", 0, 1) 
	await get_tree().create_timer(0.5384).timeout
	queue_free()
