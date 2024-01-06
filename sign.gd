extends StaticBody3D
@export_category("Text")
@export var text: String

func _ready():
	$Label3D.text = text
