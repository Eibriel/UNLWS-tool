extends Node

signal glyph_selected

var selected_glyph:Node2D
var instances := {}

func set_selected_glyph(glyph_node:Node2D):
	selected_glyph = glyph_node
	emit_signal("glyph_selected")
	
