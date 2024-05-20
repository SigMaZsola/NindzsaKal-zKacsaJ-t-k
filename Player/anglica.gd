extends RigidBody3D

@export var float_force := 0.6
@export var water_drag := 0.05
@export var water_angular_drag := 0.05
@export var turn_speed := 5.0
var speed = 15.0
var velocity = Vector3()
var turning_velocity = Vector3()
@onready var gravity: float = ProjectSettings.get_setting("physics/3d/default_gravity")
@onready var water = get_node('/root/Main/Water')
@onready var probes = $body/ProbeContainer.get_children()

var submerged := false


func _process(delta):
	if Input.is_action_pressed("hátra"):
		velocity.z = 0
	elif Input.is_action_pressed("előre"):
		velocity.z = speed * delta
	else:
		velocity.z = 0

	# Handle turning
	if Input.is_action_pressed("jobbra"):
		turning_velocity.y = -turn_speed * delta
	elif Input.is_action_pressed("balra"):
		turning_velocity.y = turn_speed * delta
	else:
		turning_velocity.y = 0

	apply_central_impulse(transform.basis.z * velocity.z)
	apply_torque_impulse(turning_velocity)

func _physics_process(delta):
	submerged = false
	for p in probes:
		var depth = water.get_height(p.global_position) - p.global_position.y 
		if depth > 0:
			submerged = true
			apply_force(Vector3.UP * float_force * gravity * depth, p.global_position - global_position)

func _integrate_forces(state: PhysicsDirectBodyState3D):
	if submerged:
		state.linear_velocity *= 1 - water_drag
		state.angular_velocity *= 1 - water_angular_drag
