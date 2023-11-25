extends Glyph

func _ready():
	setup("cat")
	register_area($Area)
	register_binding_point($BindingPoint1)
	register_line($Line1)
	register_line($Line2)
