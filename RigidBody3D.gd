extends RigidBody3D

func _on_area_3d_body_entered(body):
	if body.name == "Player":
		var direction = global_transform.origin - body.global_transform.origin
		direction = direction.normalized()
		apply_central_impulse(direction * 2)
