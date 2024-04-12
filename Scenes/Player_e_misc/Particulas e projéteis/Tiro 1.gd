extends CharacterBody2D

var direction

var speed = 300 

func _process(delta):
	position += velocity * speed * delta * direction
