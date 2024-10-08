extends Area2D

var dano = 3
var speed = 3000
var enemy_proj = false

var direction = Vector2.ZERO

func tipoTiro(weapon_type):
	match weapon_type:
		"Gen-EricV1":
			dano = 4
		"Gen-EricV2":
			dano = 1
		"Peacemaker":
			dano = 2
		"Imperium":
			dano = 1
		"Killerbee":
			dano = 6
			speed = 1000
		"Heartbreak":
			dano = 99
			speed = 800
			
func tipo_tiro_boss(damage):
	dano = damage
	speed = 800
	enemy_proj = true
		
func set_bullet(position, targetPosition):
	global_position = position
	direction = (targetPosition - position).normalized()
	rotation_degrees = rad_to_deg(position.angle_to_point(targetPosition))
	
func _physics_process(delta):

	position += direction * speed * delta

func _on_area_2d_body_entered(body):
	if body.is_in_group("pedra"):
		queue_free()

func _on_area_2d_area_entered(area):
	if !enemy_proj:
		if area.is_in_group("inimigo"):
			if !player_vars.bullet_penetration:
				queue_free()
	elif area.is_in_group("player"):
		get_tree().call_group("player", "take_damage", "Heartbreak")
		queue_free()
