extends Glyph

func _ready():
	setup("cat")
	register_area($Area)
	register_binding_point($BindingPoint1)
	#register_line($Line1)
	#register_line($Line2)
	register_path($Path2D)
	register_path($Path2D2)

func get_sem_struct():
	return "CAT"
