extends TextEdit

var nxtCmd=""

#onready var other_text_edit = 
@export var otherTextEdit:TextEdit = null
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	grab_focus()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
  
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("new_line"):
		insert_text_at_caret("\n")
	elif event.is_action_pressed("send_cmd"):
		nxtCmd = text
		otherTextEdit.text = nxtCmd
		clear()
