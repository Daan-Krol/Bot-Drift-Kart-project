extends Node3D
@export var Delay = 1
@export var LTR = false

func _ready():
	
	await get_tree().create_timer(Delay).timeout
	if LTR:
		$AnimationPlayer.play("Left to right")
	else:
		$AnimationPlayer.play("Right to Left")
