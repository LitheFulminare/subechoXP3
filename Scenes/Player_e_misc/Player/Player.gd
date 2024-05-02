extends CharacterBody2D

signal died_by_explosion
#signal collect(type)

@export var speed = 500
@export var acceleration = 4500
@export var friction = 400
@export var arma1_tipo = 1
#@export var life = 100
#@export var energy = 100

var life = player_vars.max_life
var energy = player_vars.max_energy
var scrap = 0
var current_speed : float
var invincible = false
var sonar = false
var input = Vector2.ZERO
var t1_cd = false
var mudarA1_cd = false

var targetPosition: Vector2
var shootDirection: Vector2

var tween

const tiro1Path = preload("res://Scenes/Player_e_misc/Particulas e projéteis/Tiro 1.tscn") 
const muzz1Path = preload("res://Scenes/Player_e_misc/Particulas e projéteis/Muzzle 1.tscn")
const muzz2Path = preload("res://Scenes/Player_e_misc/Particulas e projéteis/Muzzle 2.tscn")

func _physics_process(delta):
	player_movement(delta)

func get_input():

	input.x = int(Input.is_action_pressed("Right")) - int(Input.is_action_pressed("Left"))
	input.y = int(Input.is_action_pressed("Down")) - int(Input.is_action_pressed("Up"))
	
	return input.normalized()
	
func player_movement(delta):
	
	input = get_input()
	if input == Vector2.ZERO:
		
		if velocity.length() > (friction * delta):
			$Sprite/TurbinaV1/Sprites.play()
			velocity -= velocity.normalized() * (friction * delta)
		else:
			velocity = Vector2.ZERO
			$Sprite/TurbinaV1/Sprites.stop()
	else:
		velocity += (input * acceleration * delta)
		velocity = velocity.limit_length(speed)
	#move_and_slide()
	
	var collision = move_and_collide(velocity * delta)
	if collision:
		#print("colisao")
		if collision.get_collider().is_in_group("explosivo"):
			collision.get_collider().kaboom()
			#get_tree().call_group("explosivo", "kaboom")
			#print("colisao explosivo")
		#print(get_last_slide_collision().get_collider())
		if not invincible && life > 0:
			#print("var colisao = true")
			print("velocidade: " + str(current_speed))
			var dano_tomado = int(current_speed/20)
			if dano_tomado < 1:
				dano_tomado = 1
			life -= dano_tomado
			#life = int(life)
			velocity = Vector2.ZERO
			invincible = true
			damage_effect()
			$iFrames.start()

func _ready():
	pass

@warning_ignore("unused_parameter")
func _process(delta):
	player_vars.current_life = life
	player_vars.current_energy = energy
	player_vars.current_scrap = scrap

	current_speed = abs(velocity.x) + abs(velocity.y)
	
	if energy <= 0:
		energy = 0
	#if Input.is_action_pressed("Right"):
	#	energy -= 1
	if Input.is_action_pressed("Sonar"):
		Sonar()
	
	if Input.is_action_pressed("Arma1"):
		tiro1()
		
	if Input.is_action_pressed("mudarArma1"):
		mudarArma1()
		
	$"Spawn Tiro 1".look_at(get_global_mouse_position())
	
	if velocity.length() > 0 :
		$Sprite/TurbinaV1/Sprites.play()
	else:
		$Sprite/TurbinaV1/Sprites.stop()
		
	$"LIght 2".look_at(get_global_mouse_position())

func _on_energy_timer_timeout():
	energy -= 1
	
func Sonar():
	if not sonar && life > 0 && energy > 0:
		$Sprite/Sonar.play()
		sonar = true
		$"Sonar cooldown".start()
		energy = energy - 5
		$Sonar.visible = true
		
		@warning_ignore("shadowed_variable")
		var tween = create_tween()
		tween.tween_property($Sonar, "scale", Vector2(55,55), 1)
		tween.parallel().tween_property($Sonar, "energy", 0, 2) 
			
		await tween.finished
		$Sonar.visible = false
		$Sonar.scale = Vector2(1,1)
		$Sonar.energy = 1.0
		$Sprite/Sonar.stop()
		
func tiro1():
	if not t1_cd && life > 0 && energy > 0:
		targetPosition = get_global_mouse_position()
		var gun_Position = $"Spawn Tiro 1".global_position
		
		if arma1_tipo == 1:
			gun_Position = $"Spawn Tiro 1".global_position
		elif arma1_tipo == 2:
			gun_Position = $"Spawn Tiro 1".global_position
		shootDirection = (targetPosition - gun_Position).normalized()
		
		@warning_ignore("shadowed_variable")
		var tiro1 = tiro1Path.instantiate()
		tiro1.set_bullet(gun_Position, targetPosition)
		tiro1.tipoTiro(arma1_tipo)
		get_parent().add_child(tiro1)
		tiro1.position = $"Spawn Tiro 1".global_position
		
		if arma1_tipo == 1: # arma lenta
			var muzz = muzz1Path.instantiate()
			get_parent().add_child(muzz)
			#$"Spawn Tiro 1".add_child(muzz)
			muzz.position = $Muzz1Local.global_position
			muzz.anim()
		elif arma1_tipo == 2: # arma rapida
			var muzz = muzz2Path.instantiate()
			get_parent().add_child(muzz)
			#$"Spawn Tiro 1".add_child(muzz)
			muzz.position = $Muzz2Local.global_position
			muzz.anim()
		
		t1_cd = true
		$"Tiro 1 cooldown".start()

func damage_effect():
	$Flash.start()
	#$FlashDur.Start()
		
func _on_sonar_cooldown_timeout():
	sonar = false


func _on_i_frames_timeout():
	invincible = false
	$Flash.stop()
	$Light.energy = 1
	$"LIght 2".energy = 1.5


func _on_flash_timeout():
	var t = randf()
	var t2 = randf()
	$Light.energy = t
	$"LIght 2".energy = t2


func _on_tiro_1_cooldown_timeout():
	t1_cd = false

func _on_area_2d_area_entered(area): 
	print("colisao") #essa linha nao tá sendo chamada
	if area.is_in_group("inimigo"):
		print("colisao com inimigo")
		
func mudarArma1():
	if not mudarA1_cd:
		if arma1_tipo == 1:
			arma1_tipo = 2
			$"Colisão arma 1 v1".disabled = true
			$"Colisão arma 1 v2".disabled = false
			$"Sprite/Arma1/Sprites 1".visible = false
			$"Sprite/Arma1/Sprites 2".visible = true
			$"Tiro 1 cooldown".wait_time = 0.25
		
		else:
			arma1_tipo = 1
			$"Colisão arma 1 v1".disabled = false
			$"Colisão arma 1 v2".disabled = true
			$"Sprite/Arma1/Sprites 1".visible = true
			$"Sprite/Arma1/Sprites 2".visible = false
			$"Tiro 1 cooldown".wait_time = 0.8
			
		mudarA1_cd = true
		$"mudarArma1 Cooldown".start()
		
func death_no_life():
	$Sprite.visible = false
	$Light.visible = false
	$"LIght 2".visible = false
	$Sonar.visible = false
	
func death_no_energy():
	var tween = create_tween()
	tween.tween_property($Light, "energy", 0, 1)
	tween.parallel().tween_property($"LIght 2", "energy", 0, 2) 
	

func _on_mudar_arma_1_cooldown_timeout():
	mudarA1_cd = false
	
#func kaboom():
	#died_by_explosion.emit()


func collect(type):
	var scrap_earned
	
	if type == "plastic":
		scrap_earned = randi_range(1,2)
		
	if type == "bootle":
		scrap_earned = randi_range(3,5)
		
	if type == "fish":
		scrap_earned = randi_range(6,8)
	
	if type == "metal":
		scrap_earned = randi_range(8,12)
		
	scrap += scrap_earned
