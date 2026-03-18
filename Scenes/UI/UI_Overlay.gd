extends Control

func _process(delta):
	$Rankings/Names/Label1.text = str(Global.Racers[0].Name)
	$Rankings/Names/Label2.text = str(Global.Racers[1].Name)
	$Rankings/Names/Label3.text = str(Global.Racers[2].Name)
	$Rankings/Names/Label4.text = str(Global.Racers[3].Name)
	$Rankings/Names/Label5.text = str(Global.Racers[4].Name)
	$Rankings/Names/Label6.text = str(Global.Racers[5].Name)
