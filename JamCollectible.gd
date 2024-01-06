extends Node3D

var gave_jam = false

func _on_area_3d_body_entered(body):
	if body.name == "Player" and self.visible == true:
		self.visible = false
		if gave_jam == false:
			body.jams += 1
			gave_jam = true
			$AudioStreamPlayer3D.play()
		await get_tree().create_timer(1).timeout
		queue_free()
func _process(delta):
	self.rotation.y += 2 * delta
