extends TextEdit

var highlighter = CodeHighlighter.new()
var title_style = StyleBoxFlat.new()
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	syntax_highlighter = highlighter
	highlighter.add_color_region("[", "]", Color(0.851, 0.833, 0.845), true)
	title_style.bg_color = Color(0.102, 0.106, 0.149, 0)
	self.add_theme_stylebox_override("normal", title_style)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
