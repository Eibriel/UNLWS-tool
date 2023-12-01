extends Node2D
class_name Glyph

var id: String
var instance_name: String
var main_area: Area2D
var binding_points: Array[Area2D]
var lines: Array[Line2D]
var paths: Array[Path2D]
var slots: Dictionary

var grabbing := false
var initial_grab_pos:Vector2
var bind_point_uuid := 0

func setup(_id: String) -> void:
	id = _id
	instance_name = "%s_%d" % [id, Global.generate_uuid(_id)]

func register_area(_main_area: Area2D) -> void:
	main_area = _main_area
	main_area.monitoring = false
	main_area.monitorable = false
	main_area.set_collision_layer_value(1, false)
	main_area.set_collision_layer_value(2, true)
	main_area.set_meta("type", "area")
	main_area.set_meta("glyph", instance_name)
	main_area.connect("input_event", _on_area_input_event)

func register_line(_line: Line2D) -> void:
	lines.append(_line)
	_line.width = 5
	_line.antialiased = true
	_line.default_color = Color.DARK_BLUE
	_line.joint_mode = Line2D.LINE_JOINT_BEVEL
	_line.begin_cap_mode = Line2D.LINE_CAP_ROUND
	_line.end_cap_mode = Line2D.LINE_CAP_ROUND

func register_path(_path: Path2D) -> void:
	paths.append(_path)

func line_color(color:int) -> void:
	for l in lines:
		match color:
			0:
				l.default_color = Color.DARK_BLUE
			1:
				l.default_color = Color.DARK_GREEN

func register_binding_point(binding_point: Area2D) -> void:
	if binding_points.has(binding_point): return
	binding_point.set_meta("type", "binding_point")
	binding_point.set_meta("id", "%d" % bind_point_uuid)
	binding_point.set_meta("glyph", instance_name)
	binding_points.append(binding_point)
	bind_point_uuid += 1

func register_slot(_name: String, slot: Area2D) -> void:
	slots[_name] = slot
	slot.set_meta("type", "slot")
	slot.set_meta("id", _name)
	slot.set_meta("glyph", id)

func distance_to_line(click_position: Vector2) -> float:
	var min_distance := 999999.0
	var local_pos := to_local(click_position)
	for path in paths:
		var point := path.curve.get_closest_point(local_pos)
		var dist := local_pos.distance_to(point)
		if dist < min_distance:
			min_distance = dist
	return min_distance

func _draw() -> void:
	for path in paths:
		var baked_points := path.curve.get_baked_points()
		var base_color := Color.DARK_BLUE
		#print(base_color)
		#draw_polyline(baked_points, base_color*0.2, 2, true)
		draw_polyline(baked_points, base_color, 4, true)
		#draw_polyline(baked_points, base_color*1.5, 0.5, true)

func _on_area_input_event(_viewport: Viewport, event:InputEvent, _shape_idx: int) -> void:
	if event is InputEventMouseButton:
		var mouse_event := event as InputEventMouseButton
		if mouse_event.button_index == 1:
			if mouse_event.pressed:
				Global.refresh_selection(mouse_event.position)
				if false:
					initial_grab_pos = mouse_event.position-position
					grabbing = true
					Global.set_selected_glyph(self)
					#print("CLICK")

func grab(click_position:Vector2) -> void:
	initial_grab_pos = click_position-position
	grabbing = true

func _input(event:InputEvent) -> void:
	if event is InputEventMouseMotion:
		var mouse_event := event as InputEventMouseMotion
		if grabbing:
			position = mouse_event.position-initial_grab_pos
	if event is InputEventMouseButton:
		var mouse_event := event as InputEventMouseButton
		if mouse_event.button_index == 1:
			if not mouse_event.pressed:
				grabbing = false
			#else:
			#	Global.refresh_selection(event.position)
			#	Global.select_glyph(event.position)
			#	Global.selected_glyph.grabbing = true

func get_instance() -> Dictionary:
	var inst := {
		"id": id,
		"instance_name": instance_name,
		"connections": []
	}
	var used_gliphs:Array[String] = []
	# Get other Areas touching my slots
	for s: String in slots:
		var slot := slots[s] as Area2D
		if slot.has_overlapping_areas():
			var ov := slot.get_overlapping_areas()
			var binded_glyphs := get_areas(ov)
			for bg in binded_glyphs:
				used_gliphs.append(bg.get_meta("glyph"))
				(inst["connections"] as Array).append([slot.get_meta("id"), bg.get_meta("glyph")])
	
	# For each glyph
	# for each unused binding point
	# get min distance to lines
	# take Normal into account
	for binding_point in binding_points:
		#var binding_point = binding_points[b] as Area2D
		print(binding_point.has_overlapping_areas())
		if !binding_point.has_overlapping_areas():
			var min_distance := 999999.0
			var sel:Glyph
			for g: Glyph in Global.glyphs_node.get_children():
				if g == self: continue
				var dist := g.distance_to_line(binding_point.global_position)
				if dist < min_distance:
					min_distance = dist
					sel = g
			if sel != null:
				(inst["connections"] as Array).append([binding_point.get_meta("id"), sel.instance_name])
	
	# Get other binding points touching my area
	if false:
		if main_area.has_overlapping_areas():
			var ov := main_area.get_overlapping_areas()
			var binded_glyphs := get_binding_points(ov)
			for bg in binded_glyphs:
				if used_gliphs.has(bg.get_meta("glyph")): continue
				(inst["connections"] as Array).append(bg.get_meta("glyph"))
	return inst

func get_areas(areas: Array[Area2D]) -> Array[Area2D]:
	var r:Array[Area2D] = []
	for a in areas:
		if a.get_meta("type") == "binding_point":
		#if a == main_area: continue
		#if a.get_meta("type") == "area":
			r.append(a)
	return r

func get_binding_points(areas: Array[Area2D]) -> Array[Area2D]:
	var r:Array[Area2D] = []
	for a in areas:
		if binding_points.has(a): continue
		if a.get_meta("type") == "binding_point":
			r.append(a)
	return r
