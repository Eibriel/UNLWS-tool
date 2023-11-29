extends Glyph

func _ready():
	setup("not_rel")
	register_area($Area)
	register_binding_point($BindingPoint1)
	register_slot("bypass", $Slot_Any)
	#register_line($Line2D)
	#register_line($Line2D2)
	register_path($Path2D)
	register_path($Path2D2)
