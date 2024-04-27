extends RigidBody3D

@export var float_force := 0.6
@export var water_drag := 0.05
@export var water_angular_drag := 0.05
var movement_speed
var speed = 15
var velocity = Vector3()
@onready var gravity: float = ProjectSettings.get_setting("physics/3d/default_gravity")
@onready var water = get_node('/root/Main/Water')

@onready var probes = $body/ProbeContainer.get_children()

var submerged := false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.

func _process(delta):
	#Ha előre gombot nyomsz akkor a hajó megindul és nem áll meg addig, amíg a hátrát nem nyomod. Ugyan ez a kormányzással, hogy legyen egy max fordulatszám és akkora sebességgel forduljon, mindaddig fordulni fog amíg nullában nem lesz.
	if Input.is_action_pressed("előre"):
		velocity.z = speed*delta
		
	apply_central_impulse(velocity)
	

func _physics_process(delta):
	submerged = false
	for p in probes:
		var depth = water.get_height(p.global_position) - p.global_position.y 
		if depth > 0:
			submerged = true
			apply_force(Vector3.UP * float_force * gravity * depth, p.global_position - global_position)

func _integrate_forces(state: PhysicsDirectBodyState3D):
	if submerged:
		state.linear_velocity *=  1 - water_drag
		state.angular_velocity *= 1 - water_angular_drag 
