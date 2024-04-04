extends CharacterBody2D

@export var speed = 500
@export var acceleration = 500
@export var friction = 100
@export var life = 100
@export var energy = 100

var sonar = false

var input = Vector2.ZERO

var tween

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
			velocity -= velocity.normalized() * (friction * delta)
		else:
			velocity = Vector2.ZERO
	else:
		velocity += (input * acceleration * delta)
		velocity = velocity.limit_length(speed)
	move_and_slide()

func _ready():
	pass

func _process(delta):
	#if energy <= 0:
	#	energy = 0
	#if Input.is_action_pressed("Right"):
	#	energy -= 1
	if Input.is_action_pressed("Sonar"):
		Sonar()

func _on_energy_timer_timeout():
	energy -= 1
	
func Sonar():
	if not sonar:
		sonar = true
		$"Sonar cooldown".start()
		energy = energy - 10
		$Sonar.visible = true
		
		var tween = create_tween()
		tween.tween_property($Sonar, "scale", Vector2(20,20), 1)
		tween.parallel().tween_property($Sonar, "energy", 0, 2)
		
		await tween.finished
		$Sonar.visible = false
		$Sonar.scale = Vector2(1,1)
		$Sonar.energy = 1.0

	

	#tween.tween_callback($Sonar.queue_free)
	
	#search for "on finished" signal for the tween. it kinda works bit it only shrinks
	


func _on_sonar_cooldown_timeout():
	sonar = false
