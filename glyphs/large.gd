extends Glyph

func _ready():
	setup("large")
	register_area($Area)
	register_binding_point($BindingPoint1)
	register_line($Line2D)
