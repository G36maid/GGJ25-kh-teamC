extends TextEdit

@export var other_text_edit:TextEdit = null

var ret_ptn  = RegEx.new()
var goto_ptn = RegEx.new()
var grab_ptn = RegEx.new()
var drop_ptn = RegEx.new()
var spc_ptn  = RegEx.new()

func _ready() -> void:
	ret_ptn.compile(r"return\s*$")
	goto_ptn.compile(r"goto\s*(ally[0-4]|hq)\s*$")
	grab_ptn.compile(r"grab\s*(food|ammo|metal)\s*([0-9]+)\s*$")
	drop_ptn.compile(r"drop\s*(food|ammo|metal)\s*([0-9]+)\s*$")
	spc_ptn.compile(r"\s+")
	var t = "       r      t    e   "
	var result = spc_ptn.search(t)
	if(result != null):
		# print("parsed string$%s^ends" %result.get_string())
		# print(spc_ptn.sub(t, " ", true))
		# print(spc_ptn.sub(t, "", true))
		pass
	else:
		print("no match")

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
	var empty_cmd_idx: int= cmds.find("") | cmds.find("\n");
	var parsed_cmds:Array[PackedStringArray]
	print("New cmds: %s" %new_cmds)
	while(empty_cmd_idx != -1):
		print("remove empty string")
		cmds.remove_at(empty_cmd_idx);
		cmds.resize(cmds.size()-1)
		empty_cmd_idx = cmds.find("")
	print("New cmds: %s" %new_cmds)

	var invalid_cmd_indices:Array[int];
	for i in cmds.size():
		if(ret_ptn.search(cmds[i])):
			print("return at %d" %i)
			parsed_cmds.append(cmds[i].strip_edges().rsplit(" ", true, 0))
		elif(goto_ptn.search(cmds[i])):
			print("goto at %d" %i)
			parsed_cmds.append(spc_ptn.sub(cmds[i].strip_edges(), " ", true).rsplit(" ", true, 1))
		elif(grab_ptn.search(cmds[i])):
			print("grab at %d" %i)
			parsed_cmds.append(spc_ptn.sub(cmds[i].strip_edges(), " ", true).rsplit(" ", true, 2))
		elif(drop_ptn.search(cmds[i])):
			print("drop at %d" %i)
			parsed_cmds.append(spc_ptn.sub(cmds[i].strip_edges(), " ", true).rsplit(" ", true, 2))
		else:
			invalid_cmd_indices.append(i)
			print("no match at %d" % i)
	for idx in invalid_cmd_indices:
		cmds.remove_at(idx)
		cmds.resize(cmds.size()-1)
		
	print(parsed_cmds)


	# for cmd in cmds:
	# 	print(cmd)
# on msg editing : send signal
# on msg sent : send signal
		
# cmd format: 
# [action] [resource type] [quantity] <new_line>
# [src] to [dest] <send_cmd> | <new_line>
