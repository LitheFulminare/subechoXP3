extends Node2D

func flip():
	$"Sprites 1".flip_h = true
	$"Sprites 1".offset = Vector2(-2,7)
	
	$"Sprites 2".flip_h = true
	$"Sprites 2".offset.x = -2
	
	#$"Sprites 3".flip_h = true
	#$"Sprites 3".offset.x = 3

func unflip():
	$"Sprites 1".flip_h = false
	$"Sprites 1".offset = Vector2(7,7)
	
	$"Sprites 2".flip_h = false
	$"Sprites 2".offset.x = 7
