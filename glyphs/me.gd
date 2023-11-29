extends Glyph

func _ready():
	setup("me")
	register_area($Area)
	register_binding_point($BindingPoint1)
	#register_line($Line1)
	register_path($Path2D)
