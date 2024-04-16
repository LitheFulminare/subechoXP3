extends CharacterBody2D

@export var speed = 500
@export var acceleration = 500
@export var friction = 100
@export var life = 100
@export var energy = 100

var invincible = false
var sonar = false
var input = Vector2.ZERO
var t1_cd = false

var targetPosition: Vector2
var shootDirection: Vector2

var tween

const tiro1Path = preload("res://Scenes/Player_e_misc/Particulas e projéteis/Tiro 1.tscn") 
const muzz1Path = preload("res://Scenes/Player_e_misc/Particulas e projéteis/Muzzle 1.tscn")

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
	
	var collision = move_and_slide()
	if collision:
		if not invincible && life > 0:
			life -= 10
			velocity = Vector2.ZERO
			invincible = true
			damage_effect()
			$iFrames.start()

func _ready():
	pass

@warning_ignore("unused_parameter")
func _process(delta):
	#if energy <= 0:
	#	energy = 0
	#if Input.is_action_pressed("Right"):
	#	energy -= 1
	if Input.is_action_pressed("Sonar"):
		Sonar()
	
	if Input.is_action_pressed("Arma1"):
		tiro1()
		
	$"Spawn Tiro 1".look_at(get_global_mouse_position())
	
	if velocity.length() > 0 :
		$Sprite/TurbinaV1/Sprites.play()
	else:
		$Sprite/TurbinaV1/Sprites.stop()
		
	

func _on_energy_timer_timeout():
	energy -= 1
	
func Sonar():
	if not sonar && life > 0 && energy > 0:
		$Sprite/Sonar.play()
		sonar = true
		$"Sonar cooldown".start()
		energy = energy - 10
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
		shootDirection = (targetPosition - global_position).normalized()
		
		@warning_ignore("shadowed_variable")
		var tiro1 = tiro1Path.instantiate()
		tiro1.set_bullet(global_position, targetPosition)
		get_parent().add_child(tiro1)
		tiro1.position = $"Spawn Tiro 1".global_position
		
		var muzz = muzz1Path.instantiate()
		get_parent().add_child(muzz)
		#$"Spawn Tiro 1".add_child(muzz)
		muzz.position = $"Spawn Tiro 1".global_position
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


func _on_flash_timeout():
	var t = randf()
	$Light.energy = t


func _on_tiro_1_cooldown_timeout():
	t1_cd = false
	
