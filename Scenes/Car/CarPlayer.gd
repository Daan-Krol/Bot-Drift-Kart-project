extends CarMain

var acceleration = 86
var steering = 9.0
var botsteering = steering

	

func _physics_process(_delta):
	Model.transform.origin = Ball.transform.origin
	Ball.apply_central_force(-Model.global_transform.basis.z * speed_input * Boost * SmallBoost)
	$Label.text = "Laps: " + str(Lap) + " NextPoint: " + str(NextPoint) + " Distance From Point: " + str(round(DistancePoint)) +  " Self Position: " + str(get_node("Ball").global_transform.origin)

func _process(delta):
	RacePos = int(str(Lap).pad_zeros(3)+str(NextPoint).pad_zeros(3)+str(round(DistancePoint)).pad_zeros(3))
	DriftStages()
	
	if not Raycast.is_colliding():
		return
		
	speed_input = 0
	speed_input += Input.get_action_strength("Accelerate")
	speed_input -= Input.get_action_strength("Brake")
	speed_input *= acceleration
	
	rotate_input = 0
	rotate_input += Input.get_action_strength("SteerLeft")
	rotate_input -= Input.get_action_strength("SteerRight")
	rotate_input *= deg_to_rad(steering)

	RightWheel.rotation.y = rotate_input
	LeftWheel.rotation.y = rotate_input

	if Input.is_action_just_pressed("Drift") and not Drifting and rotate_input != 0 and speed_input > 0 and SmallBoost == 1.0:
		StartDrift()
		

	
	if Drifting:
		rotate_input = DriftDirection + DriftAmount
		DriftAmount += Input.get_action_strength("SteerLeft") - Input.get_action_strength("SteerRight")
		DriftAmount *= deg_to_rad(steering*0.55)

	if (Drifting and Input.is_action_just_released("Drift")) or (Drifting and speed_input < 1) or (Ground == "NotRoad"):
		StopDrift()

	if Ball.linear_velocity.length() > turn_stop_limit:
		RotateCar(delta)
