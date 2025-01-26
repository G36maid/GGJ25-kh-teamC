extends Label

var label_style = StyleBoxFlat.new()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	label_style.bg_color = Color(0.102, 0.106, 0.149)
	label_style.border_color = Color(0.455, 0.812, 0.757)
	label_style.set_border_width_all(2)
	label_style.set_corner_radius_all(5)
	label_style.set_border_width(SIDE_LEFT, 0)
	self.add_theme_stylebox_override("normal", label_style)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
