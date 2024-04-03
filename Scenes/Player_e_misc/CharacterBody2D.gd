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
	if energy <= 0:
		energy = 0
	#if Input.is_action_pressed("Right"):
	#	energy -= 1
	if Input.is_action_pressed("Sonar"):
		Sonar()

func _on_energy_timer_timeout():
	energy -= 1
	
func Sonar():
	#$Sonar.visible = true
	var tween = get_tree().create_tween()
	tween.tween_property($Sonar, "scale", Vector2(), 0.5)
	#tween.tween_callback($Sonar.queue_free)
	
	#search for "on finished" signal for the tween. it kinda works bit it only shrinks
	
