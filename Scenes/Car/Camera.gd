extends Node3D

@onready var target: Object = get_parent().get_node("Model")
@onready var camera: Object = get_node("Cam")
@export var smooth: float
@export var offset: Vector3

func _process(delta):
	if target != null:
		self.transform.origin = lerp(self.transform.origin, target.transform.origin + offset, smooth * delta)
		self.rotation = target.rotation
