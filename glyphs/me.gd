extends Glyph

func _ready() -> void:
	setup("me")
	register_area($Area as Area2D)
	register_binding_point($BindingPoint1 as Area2D)
	#register_line($Line1)
	register_path($Path2D as Path2D)
