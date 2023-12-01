extends Glyph

func _ready() -> void:
	setup("identity")
	register_area($Area as Area2D)
	register_binding_point($BindingPoint1 as Area2D)
	register_slot("bypass", $Slot_Any as Area2D)
	#register_line($Line2D)
	register_path($Path2D as Path2D)

func get_sem_struct() -> String:
	return "IDENTITY"
