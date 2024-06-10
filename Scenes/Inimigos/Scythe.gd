extends Area2D

var dano = 10
var speed = 1500
var enemy_proj = false

var direction = Vector2.ZERO

func tipo_tiro_boss(damage):
	dano = damage
	speed = 800
	enemy_proj = true
	
func flip():
	$Sprite2D.flip_h = true

func set_bullet(position, targetPosition):
	global_position = position
	direction = (targetPosition - position).normalized()
	rotation_degrees = rad_to_deg(position.angle_to_point(targetPosition))
	
func _physics_process(delta):

	position += direction * speed * delta

func _on_area_entered(area):
	if area.is_in_group("player"):
		get_tree().call_group("player", "take_damage", "inimigo")
	
	#if !area.is_in_group("inimigo"):
		#queue_free()
