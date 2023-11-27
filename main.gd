extends Control

@onready var glyphs_node = $Glyphs
@onready var glyph_list_container = $GlyphListContainer
@onready var glyph_rotation = $GlyphRotation
@onready var tmr_text_label = $TMRTextLabel
@onready var turn_button = $TurnButton

var glyph_list = {
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

var instances = {}
var grabbing := false
var initial_grab_pos:Vector2
var visible_areas := false
var player_turn := true

func _ready():
	Global.connect("glyph_selected", _on_glyph_selected)
	for l in glyph_list:
		var b := Button.new()
		b.text = l
		b.connect("button_up", _on_add_glyph.bind(glyph_list[l]))
		glyph_list_container.add_child(b)

func _input(event):
	if event is InputEventMouseMotion:
		if grabbing:
			glyphs_node.position = event.position-initial_grab_pos
	if event is InputEventMouseButton:
		if event.button_index == 2:
			if event.pressed:
				initial_grab_pos = event.position-glyphs_node.position
				grabbing = true
			if not event.pressed:
				grabbing = false

func _on_add_glyph(scene:PackedScene):
	var g: Glyph = scene.instantiate()
	g.position = Vector2(300, 300)
	g.scale = Vector2.ONE * 0.5
	glyphs_node.add_child(g)
	if !player_turn:
		g.line_color(1)

func _on_glyph_selected():
	glyph_rotation.value = rad_to_deg(Global.selected_glyph.rotation)

func _on_glyph_rotation_value_changed(value:float):
	Global.selected_glyph.rotation = deg_to_rad(value)

func _on_generate_tmr_button_up():
	instances = {}
	for g in glyphs_node.get_children():
		g = g as Glyph
		var i = g.get_instance()
		instances[i.instance_name] = i
	var text := "TMR:\n"
	for i in instances:
		var t:= get_description(i)
		if t != "":
			text += t
			text += "\n"
	tmr_text_label.text = text

func get_description(i:String)->String:
	var id = instances[i].id
	if not ["remember", "eats", "identity", "is_rel_true", "rel_what", "not_rel"].has(id): return ""
	var description := ""
	var _name := i
	if instances[i].prop.size() > 0:
		description += " is "
	for p in instances[i].prop:
		description += "%s " % p
	if instances[i].has("agent"):
		_name = "%s %s" % [instances[i]["agent"], _name]
	if instances[i].has("theme"):
		_name = "%s %s" % [_name, instances[i]["theme"]]
	return "%s%s" % [_name, description]

func _on_clear_button_button_up():
	for g in glyphs_node.get_children():
		glyphs_node.remove_child(g)

func _on_debug_button_button_up():
	visible_areas = !visible_areas
	get_tree().set_debug_collisions_hint(visible_areas)


func _on_turn_button_button_up():
	player_turn = !player_turn
	if player_turn:
		turn_button.text = "Player Turn"
	else:
		turn_button.text = "AI Turn"
