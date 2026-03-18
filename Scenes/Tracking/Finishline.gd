extends Area3D


func _on_body_entered(body):
	if body.is_in_group("Car"):
		if body.get_parent().NextPoint > body.get_parent().Points.size() * 0.75:
			body.get_parent().Lap += 1
			body.get_parent().NextPoint = 0
