extends StaticBody2D

var turned_off = false
@export_range(0,1000) var value : int

func _process(delta):
	if !turned_off:
		$"Green label".text = str(value)
		$"Red label".text = str(value)
		if player_vars.current_scrap >= value:
			$"Green label".visible = true
			$"Red label".visible = false
		else:
			$"Green label".visible = false
			$"Red label".visible = true
	
func turn_off():
	$Lights.visible = false
	$"Green label".visible = false
	$"Red label".visible = false
	turned_off = true
