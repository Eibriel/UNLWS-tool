extends Glyph

func _ready() -> void:
	setup("rel_what")
	register_area($Area as Area2D)
	register_slot("bypass", $Slot_Any as Area2D)
	#register_line($Line2D)
	#register_line($Line2D3)
	register_path($Path2D as Path2D)
	register_path($Path2D2 as Path2D)
