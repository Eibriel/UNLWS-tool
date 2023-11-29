extends Glyph

func _ready():
	setup("remember")
	register_area($Area)
	register_slot("agent", $Slot_Agent)
	register_slot("theme", $Slot_Theme)
	#register_line($Line1)
	#register_line($Line2)
	register_path($Path2D)
	register_path($Path2D2)
