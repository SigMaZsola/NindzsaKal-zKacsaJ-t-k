extends Node3D

func _process(delta):
	$camera.global_transform.origin = $Angelica/Marker3D.global_transform.origin
