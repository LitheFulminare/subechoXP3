extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass

	
func _process(delta):
	pass
	#position = get_node("Spawn Tiro 1").global_position
	

	
func anim():
	
	$animacao.play()
	var tween = create_tween()
	tween.tween_property($luz, "scale", Vector2.ZERO, 1)
	tween.parallel().tween_property($luz, "energy", 0, 1) 
	await get_tree().create_timer(0.5384).timeout
	queue_free()


func _on_area_2d_body_entered(body):
	if body.is_in_group("player"):
		body.life = 0
