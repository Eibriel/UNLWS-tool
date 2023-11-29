extends Glyph

func _ready():
	setup("rel_what")
	register_area($Area)
	register_slot("bypass", $Slot_Any)
	#register_line($Line2D)
	#register_line($Line2D3)
	register_path($Path2D)
	register_path($Path2D2)
