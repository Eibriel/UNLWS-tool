extends Glyph

func _ready() -> void:
	setup("not_rel")
	register_area($Area as Area2D)
	register_binding_point($BindingPoint1 as Area2D)
	register_slot("bypass", $Slot_Any as Area2D)
	#register_line($Line2D)
	#register_line($Line2D2)
	register_path($Path2D as Path2D)
	register_path($Path2D2 as Path2D)
