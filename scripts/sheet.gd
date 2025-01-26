extends TextEdit

var sheet_style = StyleBoxFlat.new()
var highlighter = CodeHighlighter.new()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	self.add_theme_stylebox_override("normal", sheet_style)
	syntax_highlighter = highlighter
	sheet_style.bg_color = Color(0.102, 0.106, 0.149)
	sheet_style.border_color = Color(0.455, 0.812, 0.757)
	sheet_style.set_border_width_all(2)
	sheet_style.set_corner_radius_all(5)
	#sheet_style.
	var actions:PackedStringArray = ["return", "goto", "grab", "drop"]
	var resources:PackedStringArray = ["food", "ammo", "metal"]
	var locations:PackedStringArray = ["ally0", "ally1", "ally2", "ally3", "ally4", "hq"]
	for str in actions:
		highlighter.add_keyword_color(str, Color(0.9, 0.669, 0.657))
	for str in resources:
		highlighter.add_keyword_color(str, Color(0.594, 0.749, 0.94))
	for str in locations:
		highlighter.add_keyword_color(str, Color(0.795, 0.372, 0.423))
	# highlighter.add_color_region("=", "=", Color(0.774, 0.428, 0.844), true)
	highlighter.set_number_color(Color(0.8, 0.644, 0.92))
	highlighter.set_symbol_color(Color(0.137, 0.442, 0.633))
	#highlighter.add_member_keyword_color("g.", Color(0.455, 0.812, 0.757))
	highlighter.add_keyword_color("Command Cheatsheet", Color(0.774, 0.428, 0.844))


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
