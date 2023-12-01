extends Glyph

func _ready() -> void:
	setup("remember")
	register_area($Area as Area2D)
	register_slot("agent", $Slot_Agent as Area2D)
	register_slot("theme", $Slot_Theme as Area2D)
	#register_line($Line1)
	#register_line($Line2)
	register_path($Path2D as Path2D)
	register_path($Path2D2 as Path2D)
