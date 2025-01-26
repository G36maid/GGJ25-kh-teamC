extends TextEdit

@export var error_reporter: TextEdit = null

var ret_ptn = RegEx.new()
var goto_ptn = RegEx.new()
var grab_ptn = RegEx.new()
var drop_ptn = RegEx.new()
var spc_ptn = RegEx.new()
var highlighter = CodeHighlighter.new()

signal send_invalid_cmd(invalid_cmd)
signal send_legal_cmd(legal_cmd)
signal parse_invalid_cmds

func _ready() -> void:
	syntax_highlighter = highlighter
	ret_ptn.compile(r"return\s*$")
	goto_ptn.compile(r"goto\s*(ally[0-4]|hq)\s*$")
	grab_ptn.compile(r"grab\s*(food|ammo|metal)\s*([0-9]+)\s*$")
	drop_ptn.compile(r"drop\s*(food|ammo|metal)\s*([0-9]+)\s*$")
	spc_ptn.compile(r"\s+")
	
	var actions: PackedStringArray = ["return", "goto", "grab", "drop"]
	var resources: PackedStringArray = ["food", "ammo", "metal"]
	var locations: PackedStringArray = ["ally0", "ally1", "ally2", "ally3", "ally4", "hq"]
	for str in actions:
		highlighter.add_keyword_color(str, Color(0.9, 0.669, 0.657))
	for str in resources:
		highlighter.add_keyword_color(str, Color(0.594, 0.749, 0.94))
	for str in locations:
		highlighter.add_keyword_color(str, Color(0.795, 0.372, 0.423))
	highlighter.set_number_color(Color(0.8, 0.644, 0.92))
	highlighter.set_symbol_color(Color(0.94, 0.824, 0.573))
	
	grab_focus()

func _process(delta: float) -> void:
	pass
  
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("new_line"):
		insert_text_at_caret("\n")
	elif event.is_action_pressed("send_cmd"):
		parse_cmds(text)
		clear()

func parse_cmds(new_cmds: String) -> void:
	var cmds: PackedStringArray = new_cmds.split("\n")
	var empty_cmd_idx: int = cmds.find("")
	var parsed_cmds: Array[PackedStringArray]
	var cmd_invalid: bool = false;

	while (empty_cmd_idx != -1):
		print("remove empty string")
		cmds.remove_at(empty_cmd_idx);
		empty_cmd_idx = cmds.find("")

	for i in cmds.size():
		cmd_invalid = false;
		if (ret_ptn.search(cmds[i])):
			# print("return at %d"%i)
			parsed_cmds.append(cmds[i].strip_edges().rsplit(" ", true, 0))
		elif (goto_ptn.search(cmds[i])):
			# print("goto at %d"%i)
			parsed_cmds.append(spc_ptn.sub(cmds[i].strip_edges(), " ", true).rsplit(" ", true, 1))
		elif (grab_ptn.search(cmds[i])):
			# print("grab at %d"%i)
			parsed_cmds.append(spc_ptn.sub(cmds[i].strip_edges(), " ", true).rsplit(" ", true, 2))
		elif (drop_ptn.search(cmds[i])):
			# print("drop at %d"%i)
			parsed_cmds.append(spc_ptn.sub(cmds[i].strip_edges(), " ", true).rsplit(" ", true, 2))
		else:
			cmd_invalid=true
		if(cmd_invalid):
			send_invalid_cmd.emit(cmds[i])
		else:
			send_legal_cmd.emit(cmds[i])
	print("Valid cmds: ")
	print(parsed_cmds)
	$/root/game.send_commands_to_deliverer(parsed_cmds)
	parse_invalid_cmds.emit()
