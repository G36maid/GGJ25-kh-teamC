extends TextEdit

@export var cmd_sender:TextEdit = null

var invalid_cmds: PackedStringArray=[];
var error_msgs: PackedStringArray
var success_msgs: PackedStringArray

var highlighter = CodeHighlighter.new()

var loc_err_ptn   = RegEx.new()
var act_err_ptn   = RegEx.new()
var resrc_err_ptn = RegEx.new()
var fmt_err_ptn   = RegEx.new()
var spc_ptn       = RegEx.new()
var digit_ptn     = RegEx.new()
var actions:PackedStringArray = ["return", "goto", "grab", "drop"]
var resources:PackedStringArray = ["food", "ammo", "metal"]
var locations:PackedStringArray = ["ally0", "ally1", "ally2", "ally3", "ally4", "hq"]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	cmd_sender.connect("send_invalid_cmd", _on_send_invalid_cmd)
	cmd_sender.connect("send_legal_cmd", _on_send_legal_cmd)
	cmd_sender.connect("parse_invalid_cmds", _on_parse_invalid_cmds)
	syntax_highlighter = highlighter
	spc_ptn.compile(r"\s+")
	digit_ptn.compile(r"^\d+$")

	highlighter.add_keyword_color("Error", Color(0.77, 0.131, 0.28))
	highlighter.add_keyword_color("Success", Color(0.213, 0.804, 0.598))
	highlighter.set_symbol_color(Color(0.94, 0.824, 0.573))
	highlighter.set_number_color(Color(0.8, 0.644, 0.92))

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_send_invalid_cmd(cmd):
	invalid_cmds.append(cmd)
	error_msgs.append("[Error] "+cmd+" :")

func _on_parse_invalid_cmds():
	text=""
	for i in invalid_cmds.size():
		var sub_cmds: PackedStringArray
		var stripped_cmd = spc_ptn.sub(invalid_cmds[i].strip_edges(), " ", true)
		sub_cmds = stripped_cmd.rsplit(" ", true, stripped_cmd.count(" ", 0, 0))
		if(actions.find(sub_cmds[0])==-1):
			error_msgs[i] += " Unknown Action \"" + sub_cmds[0] + "\" !!"
		elif(sub_cmds.size()>3):
			error_msgs[i] += " Illigal Command Format !!"
		elif(sub_cmds.size()==2):
			if(sub_cmds[0]!="goto"):
				error_msgs[i] += " Illigal Command Format !!"
			else:
				error_msgs[i] += " Unknown Location \"" + sub_cmds[1] + "\" !!"
		elif(sub_cmds.size()==3):
			if(sub_cmds[0]!="drop" && sub_cmds[0]!="grab"):
				error_msgs[i] += " Illigal Command Format !!"
			elif(digit_ptn.search(sub_cmds[1])):
				error_msgs[i] += "\n\tExpect Resources But Received Numbers \"" + sub_cmds[1] + "\" !!"
			elif(resources.find(sub_cmds[1])==-1):
				error_msgs[i] += " Unknown Resource \"" + sub_cmds[1] + "\" !!"
			elif(!digit_ptn.search(sub_cmds[2])):
				error_msgs[i] += "\n\tExpect Numbers But Received String \"" + sub_cmds[2] + "\" !!"
	for str in success_msgs:
		text += str + "\n"
	for str in error_msgs:
		text += str + "\n"
	invalid_cmds.clear()
	error_msgs.clear()
	success_msgs.clear()

func _on_send_legal_cmd(cmd: String):
	print("set text success" + cmd)
	success_msgs.append("[Success] " + cmd)

# undefined action
# undefined resource
# undefined location
# undefined command format
