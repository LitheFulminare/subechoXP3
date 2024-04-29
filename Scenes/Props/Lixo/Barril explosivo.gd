extends StaticBody2D

signal explosao_barril(global_position)

func _ready():
	pass

func _process(delta):
	pass


func _on_area_2d_body_entered(body):
	if body.is_in_group("player"):
		pass
		#explosao_barril.emit(global_position)
		#queue_free()


func _on_area_2d_area_entered(area):
	if area.is_in_group("tiro"):
		area.get_parent().queue_free()
		explosao_barril.emit(global_position)
		queue_free()
