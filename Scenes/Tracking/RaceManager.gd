extends Node3D


func _ready():
	for r in get_parent().get_children():
		if r.is_in_group("Racer"):
			Global.Racers.append(r)

func _process(delta):
	Global.Racers.sort_custom(func(a, b): return a.RacePos > b.RacePos)

func sort_ascending(a, b):
	if a.RacePos < b.RacePos:
		return true
	return false
