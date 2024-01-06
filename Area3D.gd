extends Area3D

@onready var jamCollectible2 = get_node("../../JamCollectible2")

func _on_body_entered(body):
	if body.name == "Ball":
		jamCollectible2.visible = true
		$AudioStreamPlayer3D.play()
		await get_tree().create_timer(5).timeout
		queue_free()
