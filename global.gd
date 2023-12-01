extends Node

signal glyph_selected
signal selection_refresh(click_position: Vector2)

var selected_glyph:Glyph
var instances := {}
var glyphs_node:Node2D

var uuid := {}

func set_selected_glyph(glyph_node:Node2D) -> void:
	if glyph_node==null: return
	selected_glyph = glyph_node
	emit_signal("glyph_selected")
	
func select_glyph(click_position: Vector2) -> void:
	var min_distance := 999999.0
	var sel:Node2D
	for g: Glyph in glyphs_node.get_children():
		var dist := g.distance_to_line(click_position)
		if dist < min_distance:
			min_distance = dist
			sel = g
	set_selected_glyph(sel)

func refresh_selection(click_position: Vector2) -> void:
	emit_signal("selection_refresh", click_position)
	
func generate_uuid(_id: String) -> int:
	if not uuid.has(_id):
		uuid[_id] = 0
	uuid[_id] += 1
	return uuid[_id]
