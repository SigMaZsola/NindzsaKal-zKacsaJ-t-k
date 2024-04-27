extends Node3D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass



func _process(delta):
	$Camera.global_transform.origin = $Anglica.global_transform.origin
