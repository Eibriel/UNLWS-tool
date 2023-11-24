extends Node2D
class_name DrawGlyph

var id:=""
var _glyph_pos: Array[Vector2] = []
var _binding_pos: Array[Vector2] = []
var mode := 0
var sticky := false

const MODES := {
	"IDLE": 0,
	"DRAWING": 1,
	"ERASING": 2,
	"ADD_BINDING": 3,
	"WRITTING": 4
}

func _input(event: InputEvent) -> void:
	var gp := Vector2(position)
	if [1,3].has(mode):
		if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
			if mode == 1:
				_glyph_pos.append(event.position-gp)
			elif mode == 3:
				_binding_pos.append(event.position-gp)
			queue_redraw()
	if sticky:
		if event is InputEventMouseMotion:
			global_position = event.position
		if event is InputEventMouseButton:
			sticky = false
		queue_redraw()

func set_mode(_mode:int):
	mode = _mode

func get_glyph_pos() -> Array[Vector2]:
	return _glyph_pos.duplicate(true)

func get_binding_pos() -> Array[Vector2]:
	return _binding_pos.duplicate(true)

func set_glyph_pos(glyph_pos: Array[Vector2]) -> void:
	_glyph_pos = glyph_pos
	queue_redraw()

func set_binding_pos(binding_pos: Array[Vector2]) -> void:
	_binding_pos = binding_pos
	queue_redraw()

func reset():
	_glyph_pos.resize(0)
	_binding_pos.resize(0)
	queue_redraw()

func _draw():
	for point in _glyph_pos:
		draw_circle(point, 5, Color.DARK_BLUE)
	for point in _binding_pos:
		draw_circle(point, 5, Color.GREEN)
