extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func anim():
	$animacao.play()
	var tween = create_tween()
	tween.tween_property($luz, "scale", Vector2.ZERO, 1)
	tween.parallel().tween_property($luz, "energy", 0, 1) 
	await get_tree().create_timer(0.5384).timeout
	queue_free()
