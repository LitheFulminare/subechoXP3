extends CharacterBody2D

@export var speed = 500
@export var acceleration = 500
@export var friction = 100

var input = Vector2.ZERO

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
	pass
	

