extends Area3D


func _on_body_entered(body):
	if body.name == "Player" and self.visible == true:
		self.visible = false
		$AudioStreamPlayer3D.play()
		await get_tree().create_timer(1).timeout
		queue_free()
