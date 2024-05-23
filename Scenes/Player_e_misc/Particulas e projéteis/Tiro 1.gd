extends Area2D

var dano = 3
var speed = 3000

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
			dano == 1
		"Killerbee":
			dano == 6

func set_bullet(position, targetPosition):
	global_position = position
	direction = (targetPosition - position).normalized()
	rotation_degrees = rad_to_deg(position.angle_to_point(targetPosition))
	
func _physics_process(delta):

	position += direction * speed * delta

func _on_area_2d_body_entered(body):
	if body.is_in_group("pedra"):
		queue_free()
	#if tipo_tiro == 2: # tiro rápido/leve
		#if body.is_in_group("inimigo"):
			#queue_free()
	
