extends Glyph

func _ready():
	setup("eats")
	register_area($Area)
	register_slot("agent", $Slot_Agent)
	register_slot("theme", $Slot_Theme)
	#register_line($Line1)
	register_path($Path2D)
