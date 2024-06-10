extends Area2D

var dano = 10
var speed = 2000
var enemy_proj = false

var direction = Vector2.ZERO

func tipo_tiro_boss(damage):
	dano = damage
	speed = 1200
	enemy_proj = true
	
func flip():
	$Sprite2D.flip_h = true

func set_bullet(pos, targetPosition):
	global_position = pos
	direction = (targetPosition - pos).normalized()
	rotation_degrees = rad_to_deg(pos.angle_to_point(targetPosition))
	
func _physics_process(delta):

	position += direction * speed * delta

func _on_area_entered(area):
	if area.is_in_group("player"):
		get_tree().call_group("player", "take_damage", "inimigo")
		
	#if !area.is_in_group("inimigo"):
		#queue_free()
