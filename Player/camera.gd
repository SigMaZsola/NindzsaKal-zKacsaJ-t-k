extends Node3D

var view_sensitivity = 5.0
var mouse_input = Vector2()
@onready var eyes = $Camera3D

func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _process(delta):
	rotation_degrees.x += mouse_input.y * view_sensitivity * delta
	rotation_degrees.x = clamp(rotation_degrees.x, -80, 80)
	rotation_degrees.y -= mouse_input.x * view_sensitivity * delta

	mouse_input = Vector2()

func _input(event):
	if event is InputEventMouseMotion:
		mouse_input = event.relative

