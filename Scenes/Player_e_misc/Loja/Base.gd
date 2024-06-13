extends StaticBody2D

@export_range(0,1000) var value : int

func _process(delta):
	$"Green label".text = str(value)
	$"Red label".text = str(value)
	if player_vars.current_scrap >= value:
		$"Green label".visible = true
		$"Red label".visible = false
	else:
		$"Green label".visible = false
		$"Red label".visible = true
	
