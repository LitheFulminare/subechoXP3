extends CharacterBody2D

signal died_by_explosion
#signal collect(type)

#@export_enum("Gen-EricV1", "Gen-EricV2", "Peacemaker", "Imperium", "Killerbee") var weapon_type: String
@export var speed = 200
@export var acceleration = 150
@export var friction = 400
#@export var arma1_tipo = 1
#@export var life = 100
#@export var energy = 100

var life = player_vars.max_life
var energy = player_vars.max_energy
var weapon_type = player_vars.weapon_type
var scrap : int
var spread : int
var current_speed : float
var invincible = false
var sonar = false
var input = Vector2.ZERO
var t1_cd = false
var on_collision_with_enemy = false
var dead = false

var targetPosition: Vector2
var shootDirection: Vector2

var tween
var gun_Position
var tiro1Path
var muzz1Path

var weapon_flipped = false

func _physics_process(delta):
	player_movement(delta)

func get_input():
	
	
	input.x = int(Input.is_action_pressed("Right")) - int(Input.is_action_pressed("Left"))
	input.y = int(Input.is_action_pressed("Down")) - int(Input.is_action_pressed("Up"))
	
	return input.normalized()
	
func player_movement(delta):
	
	if !dead:
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
			if not invincible && life > 0 && not collision.get_collider().is_in_group("inimigo"):
				if not collision.get_collider().is_in_group("ignore collision"):
					if !collision.get_collider().is_in_group("boundary"):
						#print("var colisao = true")
						take_damage("cenario")
					else:
						take_damage("invisible wall")

func _ready():
	dead = false
	
	# se nenhuma arma foi selecionada, ele pega a primeira
	scrap = player_vars.current_scrap
	if weapon_type == "":
		weapon_type = "Gen-EricV1"
	
	# checa qual o tipo de arma e carrega particulas, hitbox, etc
	match weapon_type:
		"Gen-EricV1":
			tiro1Path = preload("res://Scenes/Player_e_misc/Particulas e projéteis/Tiro 1.tscn") 
			muzz1Path = preload("res://Scenes/Player_e_misc/Particulas e projéteis/Muzzle 1.tscn")
			$"Colisão Gen-EricV1".disabled = false
			$"Area2D/Colisão Gen-EricV1".disabled = false
			$"Sprite/Arma1/Sprites 1".visible = true
			$"Tiro 1 cooldown".wait_time = 0.8
			player_vars.bullet_penetration = false
			#gun_Position = $"Spawn Tiro 1".global_position
		
		"Gen-EricV2":
			tiro1Path = preload("res://Scenes/Player_e_misc/Particulas e projéteis/Tiro 2.tscn") 
			muzz1Path = preload("res://Scenes/Player_e_misc/Particulas e projéteis/Muzzle 2.tscn")
			$"Colisão Gen-EricV2".disabled = false
			$"Area2D/Colisão Gen-EricV2".disabled = false
			$"Sprite/Arma1/Sprites 2".visible = true
			$"Tiro 1 cooldown".wait_time = 0.35
			gun_Position = $"Spawn Tiro 2".global_position
			player_vars.bullet_penetration = false
		
		"Peacemaker":
			tiro1Path = preload("res://Scenes/Player_e_misc/Particulas e projéteis/Tiro 1.tscn") 
			muzz1Path = preload("res://Scenes/Player_e_misc/Particulas e projéteis/Muzzle 3.tscn")
			$"Colisão Peacemaker".disabled = false
			$"Area2D/Colisão Peacemaker".disabled = false
			$"Sprite/Arma1/Sprites 3".visible = true
			$"Tiro 1 cooldown".wait_time = 1
			gun_Position = $"Spawn Tiro 3".global_position
			player_vars.bullet_penetration = false
			spread = 70
			
		"Imperium":
			tiro1Path = preload("res://Scenes/Player_e_misc/Particulas e projéteis/Tiro 3.tscn")
			muzz1Path = preload("res://Scenes/Player_e_misc/Particulas e projéteis/Muzzle 4.tscn")
			$"Colisão Imperium".disabled = false
			$"Area2D/Colisão Imperium".disabled = false
			$"Sprite/Arma1/Sprites 4".visible = true
			$"Tiro 1 cooldown".wait_time = 0.2
			gun_Position = $"Spawn Tiro 3".global_position
			player_vars.bullet_penetration = false
			
		"Killerbee":
			tiro1Path = preload("res://Scenes/Player_e_misc/Particulas e projéteis/Tiro 4.tscn")
			muzz1Path = preload("res://Scenes/Player_e_misc/Particulas e projéteis/Muzzle 4.tscn")
			$"Colisão Killerbee".disabled = false
			$"Area2D/Colisão Killerbee".disabled = false
			$"Sprite/Arma1/Sprites 5".visible = true
			$"Tiro 1 cooldown".wait_time = 1.5
			gun_Position = $"Spawn Tiro 5".global_position
			player_vars.bullet_penetration = true

@warning_ignore("unused_parameter")
func _process(delta):
	
	$Aim.position = get_local_mouse_position().clamp(Vector2(-300,-300),Vector2(300,300))
	
	flip_weapon()
	
	
	
	player_vars.current_life = life
	player_vars.current_energy = energy
	player_vars.current_scrap = scrap

	current_speed = abs(velocity.x) + abs(velocity.y)
	
	#$"Precision Limit".look_at(get_global_mouse_position())
	
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
		
	$"Light 2".look_at(get_global_mouse_position())
	
	if on_collision_with_enemy == true && not invincible:
		take_damage("inimigo")
		
func _input(event):
	if Input.is_action_pressed("Left"):
		$Sprite/Casco.flip_h = true
		$Sprite/Sonar.flip_h = true
		#$Sprite/TurbinaV1/Sprites.flip_h = true
		$Sprite/TurbinaV1/Sprites.offset = Vector2(-11,3)
		$Sprite/TurbinaV1.rotation = deg_to_rad(180)
	
	if Input.is_action_pressed("Right"):
		$Sprite/Casco.flip_h = false
		$Sprite/Sonar.flip_h = false
		#$Sprite/TurbinaV1/Sprites.flip_h = false
		$Sprite/TurbinaV1/Sprites.offset = Vector2(-11,-3)
		$Sprite/TurbinaV1.rotation = deg_to_rad(0)

func flip_weapon():
	if get_global_mouse_position() >= global_position && weapon_flipped:
		$Sprite/Arma1.unflip()
		weapon_flipped = false
		flip_weapoon_stats()
		#$"Spawn Tiro 1".position.x = 65
		#$"Spawn Tiro 2".position.x = 88
		#$"Spawn Tiro 3".position.x = 78.635
		
	elif get_global_mouse_position() < global_position && !weapon_flipped:
		$Sprite/Arma1.flip()
		weapon_flipped = true
		flip_weapoon_stats()
		
func flip_weapoon_stats():
	match weapon_type:
		"Gen-EricV1":
			$"Spawn Tiro 1".position.x = -$"Spawn Tiro 1".position.x
			$Muzz1Local.position.x = -$Muzz1Local.position.x
			$"Colisão Gen-EricV1".scale.x = -$"Colisão Gen-EricV1".scale.x
			$"Area2D/Colisão Gen-EricV1".scale.x = -$"Area2D/Colisão Gen-EricV1".scale.x 
			if weapon_flipped:
				$"Colisão Gen-EricV1".position.x = -8.622
				$"Area2D/Colisão Gen-EricV1".position.x = -8.622
			else:
				$"Colisão Gen-EricV1".position.x = 25.622
				$"Area2D/Colisão Gen-EricV1".position.x = 25.622
			
		"Gen-EricV2":
			$"Spawn Tiro 2".position.x = -$"Spawn Tiro 2".position.x
			$Muzz1Local2.position.x = -$Muzz1Local2.position.x
			$"Colisão Gen-EricV2".scale.x = -$"Colisão Gen-EricV2".scale.x
			$"Area2D/Colisão Gen-EricV2".scale.x = -$"Area2D/Colisão Gen-EricV2".scale.x
			if weapon_flipped:
				$"Colisão Gen-EricV2".position.x = -8.622
				$"Area2D/Colisão Gen-EricV2".position.x = -8.622
			else:
				$"Colisão Gen-EricV2".position.x = 25.622
				$"Area2D/Colisão Gen-EricV2".position.x = 25.622
			
		"Peacemaker":
			$"Spawn Tiro 3".position.x = -$"Spawn Tiro 3".position.x
			$Muzz1Local3.position.x = -$Muzz1Local3.position.x
			$"Colisão Peacemaker".scale.x = -$"Colisão Peacemaker".scale.x
			$"Area2D/Colisão Peacemaker".scale.x = -$"Area2D/Colisão Peacemaker".scale.x
		"Imperium":
			$"Spawn Tiro 4".position.x = -$"Spawn Tiro 4".position.x
			$Muzz1Local4.position.x = -$Muzz1Local4.position.x
			$"Colisão Imperium".scale.x = -$"Colisão Imperium".scale.x
			$"Area2D/Colisão Imperium".scale.x = -$"Area2D/Colisão Imperium".scale.x
		"Killerbee":
			$"Spawn Tiro 5".position.x = -$"Spawn Tiro 5".position.x
			$"Colisão Killerbee".scale.x = -$"Colisão Killerbee".scale.x
			$"Area2D/Colisão Killerbee".scale.x = -$"Area2D/Colisão Killerbee".scale.x 

func _on_energy_timer_timeout():
	energy -= 1
	
func Sonar():
	if not sonar && life > 0 && energy > 0:
		$Sprite/Sonar.play()
		sonar = true
		$"Sonar cooldown".start()
		energy = energy - 2
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
		
		#var aim_limit = get_local_mouse_position().clamp(Vector2(-300,-300),Vector2(300,300))
		#print("imprecisão x: "  + str(aim_limit.x))
		#print("imprecisão y: "  + str(aim_limit.y))

		targetPosition = get_global_mouse_position()
		
		var shots = 1
		var tiro1 = tiro1Path.instantiate()
		
		var muzz = muzz1Path.instantiate()
		get_parent().add_child(muzz)
		muzz.anim()
		
		match weapon_type:
			"Gen-EricV1":
				gun_Position = $"Spawn Tiro 1".global_position
				tiro1.position = $"Spawn Tiro 1".global_position
				muzz.pos = $Muzz1Local
				
			"Gen-EricV2":
				gun_Position = $"Spawn Tiro 2".global_position
				tiro1.position = $"Spawn Tiro 2".global_position
				muzz.pos = $Muzz1Local2
				targetPosition += Vector2(randi_range(-50,50),randi_range(-50,50))
				
			"Peacemaker":
				gun_Position = $"Spawn Tiro 3".global_position
				tiro1.position = $"Spawn Tiro 3".global_position
				muzz.pos = $Muzz1Local3
				targetPosition = $Aim.global_position
				shots = 3
				
			"Imperium":
				gun_Position = $"Spawn Tiro 4".global_position
				tiro1.position = $"Spawn Tiro 4".global_position
				muzz.pos = $Muzz1Local4

			"Killerbee":
				gun_Position = $"Spawn Tiro 5".global_position
				tiro1.position = $"Spawn Tiro 5".global_position
				#tiro1.speed = 0
				muzz.visible = false
				$"Sprite/Arma1/Sprites 5".play("Unloaded")
				
		
		for i in shots:
			
			tiro1 = tiro1Path.instantiate()
			shootDirection = (targetPosition - gun_Position).normalized()
			targetPosition += Vector2(randi_range(-spread,spread),randi_range(-spread,spread))
			tiro1.set_bullet(gun_Position, targetPosition)
			
			#print(weapon_type)
			tiro1.tipoTiro(weapon_type)
			print("dano: " + str(tiro1.dano))
			
			get_parent().add_child(tiro1)
			tiro1.position = gun_Position
			
		
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
	$"Light 2".energy = 1.5


func _on_flash_timeout():
	var t = randf()
	var t2 = randf()
	$Light.energy = t
	$"Light 2".energy = t2


func _on_tiro_1_cooldown_timeout():
	if weapon_type != "Killerbee":
		t1_cd = false
	else:
		if t1_cd:
			$"Sprite/Arma1/Sprites 5".play("Recharding")
			await get_tree().create_timer(1).timeout
			$"Sprite/Arma1/Sprites 5".play("Loaded")
			t1_cd = false

func _on_area_2d_area_entered(area): 
	#print("colisao")
	if area.is_in_group("inimigo"):
		on_collision_with_enemy = true
		#take_damage("inimigo")
		#print("colisao com inimigo")
		
func _on_area_2d_area_exited(area):
	if area.is_in_group("inimigo"):
		on_collision_with_enemy = false
	
func mudarArma1(): # essa função provavelmente n vai ser usada
	pass
	#if not mudarA1_cd:
		#if arma1_tipo == 1:
			#arma1_tipo = 2
			#$"Colisão arma 1 v1".disabled = true
			#$"Colisão arma 1 v2".disabled = false
			#$"Sprite/Arma1/Sprites 1".visible = false
			#$"Sprite/Arma1/Sprites 2".visible = true
			#$"Tiro 1 cooldown".wait_time = 0.25
		#
		#else:
			#arma1_tipo = 1
			#$"Colisão arma 1 v1".disabled = false
			#$"Colisão arma 1 v2".disabled = true
			#$"Sprite/Arma1/Sprites 1".visible = true
			#$"Sprite/Arma1/Sprites 2".visible = false
			#$"Tiro 1 cooldown".wait_time = 0.8
			#
		#mudarA1_cd = true
		#$"mudarArma1 Cooldown".start()
		
func death_no_life():
	$Sprite.visible = false
	$Light.visible = false
	$"Light 2".visible = false
	$Sonar.visible = false
	dead = true
	
func death_no_energy():
	var tween = create_tween()
	tween.tween_property($Light, "energy", 0, 1)
	tween.parallel().tween_property($"Light 2", "energy", 0, 2) 
	dead = true
	

#func _on_mudar_arma_1_cooldown_timeout():
	#mudarA1_cd = false
	
#func kaboom():
	#died_by_explosion.emit()


func collect(type):
	var scrap_earned = 0
	
	if type == "plastic":
		scrap_earned = randi_range(2,4)
		
	if type == "bottle":
		scrap_earned = randi_range(5,8)
		
	if type == "fish":
		scrap_earned = randi_range(8,12)
	
	if type == "metal":
		scrap_earned = randi_range(15,20)
		
	scrap += scrap_earned
	player_vars.scrap_gained += scrap_earned
	
func regen(stat):
	match stat:
		"Recuperar vida":
			life = player_vars.max_life
		"Recuperar energia":
			energy = player_vars.max_energy
	
func change_stat(stat, qtd):
	match stat:
		"life":
			life += qtd
		"energy":
			energy += qtd
		"scrap":
			scrap += qtd
			if qtd < 0:
				player_vars.scrap_spent -= qtd

func take_damage(type):
	#print("velocidade: " + str(current_speed))
	if !invincible:
		var dano_tomado = 0
		
		match type:
			"cenario":
				dano_tomado = int(current_speed/20)
				if dano_tomado < 1:
					dano_tomado = 1
			"inimigo":
				dano_tomado = 5
			"Heartbreak":
				dano_tomado = 10
			"invisible wall":
				dano_tomado = 0
		
		life -= dano_tomado
		velocity = Vector2.ZERO
		invincible = true
		damage_effect()
		$iFrames.start()



