extends Node2D

func flip():
	$"Sprites 1".flip_h = true
	$"Sprites 1".offset = Vector2(-2,7)

func unflip():
	$"Sprites 1".flip_h = false
	$"Sprites 1".offset = Vector2(7,7)
