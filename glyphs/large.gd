extends Glyph

func _ready() -> void:
	setup("large")
	register_area($Area as Area2D)
	register_binding_point($BindingPoint1 as Area2D)
	#register_line($Line2D)
	register_path($Path2D as Path2D)
