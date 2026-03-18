extends StaticBody3D

var Car = null

func _on_area_body_entered(body):
	if body.is_in_group("Car"):
		$Timer.start()
		Car = body
		Car.get_parent().SmallBoost = 1.60
		if body.is_in_group("Bot"):
			$TimerBot.start()
			body.get_parent().steering = 18

func _on_timer_timeout():
	Car.get_parent().SmallBoost = 1


func _on_timer_bot_timeout():
	Car.get_parent().steering = Car.get_parent().botsteering
