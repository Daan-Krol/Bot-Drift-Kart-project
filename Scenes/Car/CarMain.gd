extends Node3D
class_name CarMain

@export var Name = "Vin Diesel"

@onready var Ball = $Ball
@onready var Model = $Model
@onready var Raycast = $Model/Raycast

@onready var RightWheel = $Model/Car/wheel_frontRight
@onready var LeftWheel = $Model/Car/wheel_frontLeft
@onready var CarBody = $Model/Car/body

var turn_speed = 5
var turn_stop_limit = 0.8
var body_tilt = 30

var speed_input = 0
var rotate_input = 0

var Drifting = false
var DriftDirection = 0
var DriftAmount = 0
var MinimumDrift = false

var Boost = 1
var DriftBoost = 2
var DriftStage = 0
var SmallBoost = 1.0
var Ground = "Road"

var NextPoint = 0
var Points = []
var Lap = 0
var DistancePoint = 0

var RacePos = 000000000

func _ready():
	Raycast.add_exception(Ball)
	for p in get_parent().get_node("WaypointManager").get_children():
		if p.is_in_group("Waypoint"):
			Points.append(p)
		else:
			Points.append(p.get_child(0))
	Points.append(get_parent().get_node("Finishline"))

func _process(delta):
	GroundCheck(delta)
	DistancePoint = 100 - get_node("Ball").global_transform.origin.distance_to(Points[NextPoint].position)
	
func StartDrift():
	print(Points)
	Drifting = true
	$AnimationPlayer.play("Hop")
	MinimumDrift = false
	DriftDirection = rotate_input
	$DriftTimer.start()

func StopDrift():
	if MinimumDrift and Ground == "Road":
		$Model/Boost1.emitting = true
		$Model/Boost2.emitting = true
		Boost = DriftBoost
		$BoostTimer.start()
		$AnimationPlayer.play("Camera")
	Drifting = false
	DriftStage = 0
	MinimumDrift = false

func RotateCar(delta):
	var new_basis = Model.global_transform.basis.rotated(Model.global_transform.basis.y, rotate_input)
	Model.global_transform.basis = Model.global_transform.basis.slerp(new_basis, turn_speed * delta)
	Model.global_transform = Model.global_transform.orthonormalized()
	var t = -rotate_input * Ball.linear_velocity.length() / body_tilt
	CarBody.rotation.z = lerp(CarBody.rotation.z, t, 10 * delta)

func DriftStages():
	$Model/Smoke1.emitting = MinimumDrift
	$Model/Smoke2.emitting = MinimumDrift

	if DriftStage == 1:
		$Model/Smoke1.draw_pass_1.material.albedo_color = Color(0.65, 0.65, 0.65, 1)
		DriftBoost = 1.125
	if DriftStage == 2:
		DriftBoost = 1.25
		$Model/Smoke1.draw_pass_1.material.albedo_color = Color(0.77, 0.41, 0.1, 1)
	if DriftStage == 3:
		DriftBoost = 1.6
		$Model/Smoke1.draw_pass_1.material.albedo_color = Color(0.0, 0.4, 1.0, 1)

func _on_drift_timer_timeout():
	if Drifting:
		MinimumDrift = true
		DriftStage += 1
		$DriftTimer.start()

func _on_boost_timer_timeout():
	Boost = 1
	$AnimationPlayer.play("CameraZoomOut")
	$Model/Boost1.emitting = false
	$Model/Boost2.emitting = false

func GroundCheck(delta):
	if Raycast.is_colliding():
		if Raycast.get_collider().is_in_group("NotRoad"):
			Ground = "NotRoad"
		if Raycast.get_collider().is_in_group("Road"):
			Ground = "Road"
		
	if Ground == "Road":
		Boost = 1
	if Ground == "NotRoad":
		Boost = 0.5
