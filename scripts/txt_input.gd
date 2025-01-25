extends TextEdit

var nxtCmd=""

var nxtCmd:String = ""
@export var other_text_edit:TextEdit = null
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
		other_text_edit.text = text
		parse_cmds(text)
		clear()

func parse_cmds(new_cmd: String) -> void:
	var cmds: PackedStringArray = new_cmd.split("\n")
	var illegal_cmd_idx: int= cmds.find("");
	print(cmds)
	# remove empty strings
	while(illegal_cmd_idx != -1):
		print("remove empty string at %d" %illegal_cmd_idx)
		cmds.remove_at(illegal_cmd_idx);
		illegal_cmd_idx = cmds.find("")
	# remove illegal str format

	for i in cmds.size():
		print(cmds[i])

	# for cmd in cmds:
	# 	print(cmd)
# on msg editing : send signal
# on msg sent : send signal
		
