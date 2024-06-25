extends Node

# arma e status do jogador
var max_life = 100
var max_energy = 120
var first_weapon = 1
var weapon_type : String = "Gen-EricV2"
var current_life : float
var current_energy : float
var current_scrap = 0
var current_weapon = ""

# pontuações para mostrar depois que o jogo acaba / reseta quando recomeça
var scrap_gained = 0
var scrap_spent = 0
var enemies_killed = 0

# UI da loja
var preview : int

# booleans se o jogador tem essas armas compradas ou não (outros status de arma)
var Peacemaker = false
var Imperium = false
var Killerbee = false
var bullet_penetration = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
