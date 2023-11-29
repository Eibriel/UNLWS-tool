extends Glyph

func _ready():
	setup("finished")
	register_area($Area)
	register_binding_point($BindingPoint1)
	#register_line($Line2D)
	#register_line($Line2D2)
	register_path($Path2D)
	register_path($Path2D2)
