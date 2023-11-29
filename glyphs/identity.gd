extends Glyph

func _ready():
	setup("identity")
	register_area($Area)
	register_binding_point($BindingPoint1)
	register_slot("bypass", $Slot_Any)
	#register_line($Line2D)
	register_path($Path2D)

func get_sem_struct():
	return "IDENTITY"
