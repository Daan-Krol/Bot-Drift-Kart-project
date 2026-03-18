extends CarMain

var acceleration = RandomNumberGenerator.new().randf_range(78.0, 83.0)
var steering = RandomNumberGenerator.new().randf_range(9.0, 9.8)
var botsteering = steering

var DriftLevel = 0
var Driftneg = 0

func _physics_process(_delta):
	Model.transform.origin = Ball.transform.origin
	Ball.apply_central_force(-Model.global_transform.basis.z * speed_input * Boost * SmallBoost)
	
func _process(delta):
	RacePos = int(str(Lap).pad_zeros(3)+str(NextPoint).pad_zeros(3)+str(round(DistancePoint)).pad_zeros(3))
	DriftStages()
	
	if not Raycast.is_colliding():
		return
	
	if $Model/RayCastRight.is_colliding() and $Model/RayCastLeft.is_colliding():
		$Model/RayCastWP.look_at(Points[NextPoint].global_position)
		speed_input = acceleration

	elif not $Model/RayCastRight.is_colliding():
		rotate_input = 1
		DriftLevel = 0
		acceleration * 0.4
		MinimumDrift = false
		
	elif not $Model/RayCastLeft.is_colliding():
		rotate_input = -1
		DriftLevel = 0
		speed_input = acceleration*0.4
		MinimumDrift = false
	
	if DriftLevel == 0:
		if Drifting:
			StopDrift()
	
	else:
		if not Drifting and speed_input > 0:
			StartDrift()
		Driftneg = -DriftLevel + 2
		
	
	if $Model/RayCastWP.rotation_degrees.y >= 3 or $Model/RayCastWP.rotation_degrees.y <= -3:
		if $Model/RayCastWP.rotation_degrees.y >=0:
			rotate_input = 1
		else:
			rotate_input = -1
			
	speed_input = acceleration
	if $Model/RayCastWP.rotation_degrees.y >= 65 or $Model/RayCastWP.rotation_degrees.y <= -65:
		rotate_input *= deg_to_rad(steering+1)
	else: 
		rotate_input *= deg_to_rad(steering)

	RightWheel.rotation.y = rotate_input
	LeftWheel.rotation.y = rotate_input

	if Ball.linear_velocity.length() > turn_stop_limit:
		RotateCar(delta)
	
	if Drifting:
		rotate_input = DriftDirection + DriftAmount
		DriftAmount += Driftneg
		DriftAmount *= deg_to_rad(steering*0.55)
