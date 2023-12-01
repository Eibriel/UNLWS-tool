extends Control

@onready var glyphs_node:Node2D = $Glyphs
@onready var glyph_list_container:VBoxContainer = $GlyphListContainer
@onready var glyph_rotation:HSlider = $GlyphRotation
@onready var tmr_text_label:RichTextLabel = $TMRTextLabel
@onready var turn_button:Button = $TurnButton

var glyph_list := {
	"eats": preload("res://glyphs/eats.tscn"),
	"fish": preload("res://glyphs/fish.tscn"),
	"large": preload("res://glyphs/large.tscn"),
	"me": preload("res://glyphs/me.tscn"),
	"identity": preload("res://glyphs/identity.tscn"),
	"cat": preload("res://glyphs/cat.tscn"),
	"remember": preload("res://glyphs/remember.tscn"),
	"finished": preload("res://glyphs/finished.tscn"),
	"is_rel_true": preload("res://glyphs/is_rel_true.tscn"),
	"rel_what": preload("res://glyphs/rel_what.tscn"),
	"not_rel": preload("res://glyphs/not_rel.tscn"),
}

var instances := {}
var grabbing := false
var initial_grab_pos:Vector2
var visible_areas := false
var player_turn := true

func _ready() -> void:
	Global.connect("glyph_selected", _on_glyph_selected)
	Global.connect("selection_refresh", _find_selected_glyph)
	Global.glyphs_node = glyphs_node
	for l: String in glyph_list:
		var b := Button.new()
		b.text = l
		b.connect("button_up", _on_add_glyph.bind(glyph_list[l]))
		glyph_list_container.add_child(b)

func _find_selected_glyph(click_position: Vector2) -> void:
	Global.select_glyph(click_position)
	if Global.selected_glyph != null:
		Global.selected_glyph.grab(click_position)

func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		var mouse_event := event as InputEventMouseButton
		if grabbing:
			glyphs_node.position = mouse_event.position-initial_grab_pos
	if false:
		if event is InputEventMouseButton:
			var mouse_event := event as InputEventMouseButton
			if mouse_event.button_index == 1:
				if mouse_event.pressed:
					Global.select_glyph(mouse_event.position)
					if Global.selected_glyph != null:
						Global.selected_glyph.grab(mouse_event.position)
	if event is InputEventMouseButton:
		var mouse_event := event as InputEventMouseButton
		if mouse_event.button_index == 2:
			if mouse_event.pressed:
				initial_grab_pos = mouse_event.position-glyphs_node.position
				grabbing = true
			if not mouse_event.pressed:
				grabbing = false

func _on_add_glyph(scene:PackedScene) -> void:
	var g: Glyph = scene.instantiate()
	g.position = Vector2(300, 300)
	g.scale = Vector2.ONE * 0.75
	glyphs_node.add_child(g)
	if !player_turn:
		g.line_color(1)

func _on_glyph_selected() -> void:
	glyph_rotation.value = rad_to_deg(Global.selected_glyph.rotation)

func _on_glyph_rotation_value_changed(value:float) -> void:
	Global.selected_glyph.rotation = deg_to_rad(value)

func _on_generate_tmr_button_up() -> void:
	instances = {}
	for g: Glyph in glyphs_node.get_children():
		var i := g.get_instance()
		instances[i.instance_name] = i
	print(instances)
	
	var text := ""
	for i: String in instances:
		var ii: Dictionary = instances[i]
		if (ii.connections as Array).size() == 0: continue
		text += "%s:\n" % ii.instance_name
		for c: Array in ii.connections:
			text += " - %s: %s\n" % c
		text += "\n"
	tmr_text_label.text = text

func _on_clear_button_button_up() -> void:
	for g in glyphs_node.get_children():
		glyphs_node.remove_child(g)

func _on_debug_button_button_up() -> void:
	visible_areas = !visible_areas
	get_tree().set_debug_collisions_hint(visible_areas)

func _on_turn_button_button_up() -> void:
	player_turn = !player_turn
	if player_turn:
		turn_button.text = "Player Turn"
	else:
		turn_button.text = "AI Turn"
