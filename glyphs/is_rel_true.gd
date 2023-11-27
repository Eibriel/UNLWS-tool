extends Glyph

func _ready():
	setup("is_rel_true")
	register_area($Area)
	register_binding_point($BindingPoint1)
	register_slot("bypass", $Slot_Any)
	register_line($Line2D)
	register_line($Line2D2)
	register_line($Line2D3)
	register_line($Line2D4)
