extends Node2D
class_name Glyph

var id: String
var instance_name: String
var main_area: Area2D
var binding_points: Array[Area2D]
var slots: Dictionary

var grabbing := false
var initial_grab_pos:Vector2

func setup(_id: String) -> void:
	id = _id
	instance_name = "%s_%d" % [id, randi_range(0, 9999999)]

func register_area(_main_area: Area2D) -> void:
	main_area = _main_area
	main_area.set_meta("type", "area")
	main_area.set_meta("glyph", instance_name)
	main_area.connect("input_event", _on_area_input_event)

func register_line(_line: Line2D):
	_line.width = 5
	_line.antialiased = true
	_line.default_color = Color.DARK_BLUE

func register_binding_point(binding_point: Area2D) -> void:
	if binding_points.has(binding_point): return
	binding_point.set_meta("type", "binding_point")
	binding_point.set_meta("glyph", instance_name)
	binding_points.append(binding_point)

func register_slot(_name: String, slot: Area2D) -> void:
	slots[_name] = slot
	slot.set_meta("type", "slot")
	slot.set_meta("glyph", id)

func _on_area_input_event(_viewport, event:InputEvent, _shape_idx):
	if event is InputEventMouseButton:
		if event.button_index == 1:
			if event.pressed:
				initial_grab_pos = event.position-position
				grabbing = true
				Global.set_selected_glyph(self)
				#print("CLICK")

func _input(event):
	if event is InputEventMouseMotion:
		if grabbing:
			position = event.position-initial_grab_pos
	if event is InputEventMouseButton:
		if event.button_index == 1:
			if not event.pressed:
				grabbing = false

func get_instance() -> Dictionary:
	var inst := {
		"id": id,
		"instance_name": instance_name,
		"prop": []
	}
	var used_gliphs:Array[String] = []
	# Get other Areas touching my slots
	for s in slots:
		var slot = slots[s] as Area2D
		if slot.has_overlapping_areas():
			var ov = slot.get_overlapping_areas()
			var binded_glyphs := get_areas(ov)
			for bg in binded_glyphs:
				used_gliphs.append(bg.get_meta("glyph"))
				if s == "bypass":
					inst["prop"].append(bg.get_meta("glyph"))
				else:
					inst[s] = bg.get_meta("glyph")
	
	# Get other binding points touching my area
	if main_area.has_overlapping_areas():
		var ov = main_area.get_overlapping_areas()
		var binded_glyphs := get_binding_points(ov)
		for bg in binded_glyphs:
			if used_gliphs.has(bg.get_meta("glyph")): continue
			inst["prop"].append(bg.get_meta("glyph"))
	return inst

func get_areas(areas: Array[Area2D]) -> Array[Area2D]:
	var r:Array[Area2D] = []
	for a in areas:
		#if a.get_meta("type") == "binding_point":
		if a == main_area: continue
		if a.get_meta("type") == "area":
			r.append(a)
	return r

func get_binding_points(areas: Array[Area2D]) -> Array[Area2D]:
	var r:Array[Area2D] = []
	for a in areas:
		if binding_points.has(a): continue
		if a.get_meta("type") == "binding_point":
			r.append(a)
	return r
