extends Button

var button_style = StyleBoxFlat.new()
var hover_style  = StyleBoxFlat.new()
var press_style  = StyleBoxFlat.new()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	button_style.bg_color = Color(0.103, 0.181, 0.25, 0)
	hover_style.bg_color = Color(0.4, 0.476, 0.844, 0)
	press_style.bg_color = Color(0.638, 0.929, 0.993)
	self.add_theme_stylebox_override("normal", button_style)
	self.add_theme_stylebox_override("hover", hover_style)
	# self.add_theme_stylebox_override("hover_pressed", press_style)
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
