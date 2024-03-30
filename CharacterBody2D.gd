extends CharacterBody2D


#mudar de area2D para characterBody2D, ele tem argumentos como move_and_slide que ajudam 

@export var speed = 500
@export var acceleration = 500
@export var friction = 100

var input = Vector2.ZERO

func _physics_process(delta):
	player_movement(delta)

func get_input():
	#documentação sugere isso. testar depois:
	#var input_direction = Input.get_vector("left", "right", "up", "down")
	#velocity = input_direction * speed
	input.x = int(Input.is_action_pressed("Right")) - int(Input.is_action_pressed("Left"))
	input.y = int(Input.is_action_pressed("Down")) - int(Input.is_action_pressed("Up"))
	
	#velocity = input * speed
	
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

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	

