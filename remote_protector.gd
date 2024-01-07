extends StaticBody3D

var done = false

func _on_area_3d_2_body_entered(body):
	if body.name == "Player":
		if body.jams >= 5:
			if done == false:
				$MeshInstance3D.queue_free()
				$CollisionShape3D.position = Vector3(99, 99, 99)
				done = true 


func _on_area_3d_body_entered(body):
	if body.name == "Player" and self.visible == true:
		self.visible = false
		$AudioStreamPlayer3D.play()
		await get_tree().create_timer(1).timeout
		body.finale = true
