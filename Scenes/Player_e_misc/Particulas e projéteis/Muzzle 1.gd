extends Node2D
#@onready var player = $"."
#@onready var pin_joint_2d = $PinJoint2D

# Called when the node enters the scene tree for the first time.
func _ready():
	pass
	
func _process(delta):
	pass
	#$animacao.position = $pin_joint_2d.global_position
	
func anim():
	$animacao.play()
	var tween = create_tween()
	tween.tween_property($luz, "scale", Vector2.ZERO, 1)
	tween.parallel().tween_property($luz, "energy", 0, 1) 
	await get_tree().create_timer(0.5384).timeout
	queue_free()
