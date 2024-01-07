extends StaticBody3D

var goForward = false
var goBack = false
var timer_active = false

func _process(delta):
	if goForward == true:
		$Timer.wait_time = 5.0
		$Timer.stop()
		timer_active = false
		self.global_transform.origin += -self.global_transform.basis.z * -12 * delta
	elif goBack == true:
		$Timer.wait_time = 5.0
		$Timer.stop()
		timer_active = false
		self.global_transform.origin += -self.global_transform.basis.z * 12 * delta
	elif goBack == false and goForward == false:
		if timer_active == false:
			timer_active = true
			$Timer.start(5)


func _on_area_3d_body_entered(body):
	if body.name == "Player":
		goForward = true


func _on_area_3d_body_exited(body):
	if body.name == "Player":
		goForward = false


func _on_area_3d_2_body_entered(body):
	if body.name == "Player":
		goBack = true


func _on_area_3d_2_body_exited(body):
	if body.name == "Player":
		goBack = false


func _on_timer_timeout():
	self.position = Vector3(-5.668, 7.921, 21.917)
