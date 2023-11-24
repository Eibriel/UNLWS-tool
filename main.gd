extends Node2D

@onready var mode_label = $ModeLabel
@onready var draw_glyph = $DrawGlyph
@onready var glyph_name_text_edit = $GlyphNameTextEdit
@onready var glyphs_container = $GlyphsContainer
@onready var glyphs_node = $Glyphs
@onready var log_text_label = $LogTextLabel


var mode:int = 0

class GlyphData:
	var id: String
	var glyph_pos: Array[Vector2]
	var binding_pos: Array[Vector2]

var glyphs: Dictionary

const MODES := {
	"IDLE": 0,
	"DRAWING": 1,
	"ERASING": 2,
	"ADD_BINDING": 3,
	"WRITTING": 4
}

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and not event.is_pressed():
		mode = 0
		update_mode()
	if event.is_action_pressed("draw_glyph"):
		mode = 1
		update_mode()
	elif event.is_action_pressed("draw_binding"):
		mode = 3
		update_mode()
	elif event.is_action_pressed("write"):
		mode = 0
		update_mode()
	
	queue_redraw()

func update_mode():
	const mode_names := [
		"Idle",
		"Drawing",
		"Erasing",
		"Add binding",
		"Writting"
	]
	mode_label.text = mode_names[mode]
	draw_glyph.set_mode(mode)

func update_glyph_list():
	for c in glyphs_container.get_children():
		c.queue_free()
	for gid in glyphs:
		var g = glyphs[gid]
		var b := Button.new()
		b.text = g.id
		b.connect("button_up", _on_add_glyph.bind(gid))
		glyphs_container.add_child(b)

func _on_create_button_button_up():
	if glyph_name_text_edit.text == "": return
	var g = GlyphData.new()
	g.id = glyph_name_text_edit.text
	g.glyph_pos = draw_glyph.get_glyph_pos()
	g.binding_pos = draw_glyph.get_binding_pos()
	glyphs[g.id] = g
	draw_glyph.reset()
	update_glyph_list()
	glyph_name_text_edit.text = ""

func _on_add_glyph(id: String):
	print(id)
	var glyph_scene := preload("res://glyph.tscn")
	var g := glyph_scene.instantiate()
	glyphs_node.add_child(g)
	var gd:GlyphData = glyphs[id] as GlyphData
	g.id = id
	g.set_glyph_pos(gd.glyph_pos)
	g.set_binding_pos(gd.binding_pos)
	g.sticky = true

func _draw():
	log_text_label.text = ""
	for gc in glyphs_node.get_children():
		var closest_gp:Vector2
		var closest_gpp:Vector2
		var min_dist:=999999.0
		var connection := ""
		for gcc in glyphs_node.get_children():
			if gc == gcc: continue
			var data = find_closest_bind(gc, gcc)
			if data[2] < min_dist:
				closest_gp = data[0]+gc.position
				closest_gpp = data[1]+gcc.position
				min_dist = data[2]
				connection = "%s - %s" % [gc.id, gcc.id]
		log_text_label.text += "\n%s" % connection
		draw_line(closest_gp+glyphs_node.position, closest_gpp+glyphs_node.position, Color.GREEN, 10.0)

func find_closest_bind(gc:DrawGlyph, gcc:DrawGlyph):
	var closest_gp:Vector2
	var closest_gpp:Vector2
	var min_dist:=999999.0
	for gp in gc.get_binding_pos():
		for gpp in gcc.get_binding_pos():
			var d := (gp+gc.position).distance_squared_to(gpp+gcc.position)
			if d < min_dist:
				closest_gp = gp
				closest_gpp = gpp
				min_dist = d
	return [closest_gp, closest_gpp, min_dist]


func _on_reset_glyph_button_button_up():
	draw_glyph.reset()


func _on_reset_workspace_button_button_up():
	for c in glyphs_node.get_children():
		c.queue_free()
