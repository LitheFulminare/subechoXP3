extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if player_vars.current_life >= 0:
		$"Texto Vida".text = str(player_vars.current_life)
	else:
		$"Texto Vida".text = "0"
	
	if player_vars.current_energy >= 0:
		$"Texto Energia".text = str(player_vars.current_energy)
	else: 
		$"Texto Energia".text = "0"
