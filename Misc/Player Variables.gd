extends Node

# arma e status do jogador
var max_life = 100
var max_energy = 100
var first_weapon = 1
var weapon_type : String
var current_life : float
var current_energy : float
var current_scrap : int
var current_weapon = ""

# UI da loja
var preview : int

# booleans se o jogador tem essas armas compradas ou não
var Peacemaker = false
var Imperium = false
var Killerbee = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
