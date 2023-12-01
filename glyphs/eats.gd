extends Glyph

func _ready() -> void:
	setup("eats")
	register_area($Area as Area2D)
	register_slot("agent", $Slot_Agent as Area2D)
	register_slot("theme", $Slot_Theme as Area2D)
	#register_line($Line1)
	register_path($Path2D as Path2D)
