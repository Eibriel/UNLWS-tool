extends Glyph

func _ready():
	setup("thing")
	register_area($Area)
	register_binding_point($BindingPoint1)
	register_slot("bypass", $Slot_Any)
	register_line($Line2D)
