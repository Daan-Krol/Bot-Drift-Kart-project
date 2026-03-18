extends Area3D

@export var DriftLevel = 0
@export var Dir = 0
var Bot = null

func _on_body_entered(body):
	if body.is_in_group("Player"):
		body.get_parent().SmallBoost = 1
		body.get_parent().NextPoint += 1
		
	if body.is_in_group("Bot"):
		body.get_parent().SmallBoost = 1
		body.get_parent().NextPoint += 1
		$Delay.start()
		Bot = body



func _on_delay_timeout():
	Bot.get_parent().DriftLevel = DriftLevel
