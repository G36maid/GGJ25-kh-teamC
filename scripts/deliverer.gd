class_name Deliverer
extends Node2D

@export var speed: int = 30

@onready var ally_parent = $/root/game/allys
@onready var sprite = $Sprite2D

enum State {
	Idle,
	Duty,
}
var state: State = State.Idle

var resource_food: int = 0
var resource_ammo: int = 0
var resource_metal: int = 0

var _commands: Array = []
var _next_target: String = "hq"
var can_be_scanned: bool = true

func _ready() -> void:

	sprite.visible = false

func on_radar_scanned():
	if not can_be_scanned:
		return
	can_be_scanned = false
	get_tree().create_timer(3.0).timeout.connect(func(): can_be_scanned = true)

	var s := sprite.duplicate()
	(s as Sprite2D).position = position
	(s as Sprite2D).visible = true
	get_tree().create_timer(1.0).timeout.connect(Callable(s, "queue_free"))
	get_tree().get_root().add_child(s)

	print("Radar scanned.")

func set_commands(commands: Array) -> bool:
	"""
	set commands that will be executed by deliverer.
	"""
	
	if state != State.Idle:
		printerr("Cannot set commands while deliverer is not idle.")
		return false

	_commands = commands + [["goto", "hq"]]
	state = State.Duty
	exec_commands()

	return true

func exec_commands():
	for cmd in _commands:
		state = await exec_command(cmd)

func exec_command(command: PackedStringArray) -> State:
	match command[0]:
		"goto":
			return await exec_goto(command)
		"drop":
			return await exec_drop(command)
		"grab":
			return await exec_grab(command)

	printerr("Unknown command: ", command)
	return State.Idle

func exec_goto(command: PackedStringArray) -> State:
	var target: String = command[1]
	var target_pos := await _get_target_pos(target)
	_next_target = target

	while (position - target_pos).length_squared() > 0.01:
		# TODO: inject params?
		var delta := get_process_delta_time() * speed
		position = position.move_toward(target_pos, delta)
		await get_tree().process_frame
	
	if target == "hq":
		return State.Idle
	return State.Duty

func _get_target_pos(target: String) -> Vector2:
	# ally parent is null, fallback to debug position
	if ally_parent == null:
		printerr("Ally parent is null.")
		match target:
			"ally1":
				return Vector2(100, 100)
			"ally2":
				return Vector2(200, 200)
			"hq":
				return Vector2(0, 0)
			_:
				printerr("Unknown target: ", target)
				return position
	
	var retry := 5
	for _i in retry:
		# find ally by name
		for ally in ally_parent.get_children():
			if ally.name == target:
				return ally.position

		# HACK: hard-coded path
		var hq := get_node("/root/game/hq")
		if hq != null and hq.name == target:
			return hq.position

		await get_tree().process_frame
	
	var ally_names := ally_parent.get_children()
	printerr("Ally not found: ", target, ally_names)
	return position

func exec_drop(command: PackedStringArray) -> State:
	var resource: String = command[1]
	var amount: int = int(command[2])
	var target = await _get_target()

	if not _deliver(self, target, resource, amount):
		printerr("Failed to drop resource. Skip to next cmd.")
		return State.Idle

	_debug_show_resource()
	return State.Duty

func exec_grab(command: PackedStringArray) -> State:
	var resource: String = command[1]
	var amount: int = int(command[2])
	var target = await _get_target()

	if not _deliver(target, self, resource, amount):
		printerr("Failed to grab resource. Skip to next cmd.")
		return State.Duty

	_debug_show_resource()
	return State.Duty

func _debug_show_resource():
	print("food: ", resource_food, "; ammo: ", resource_ammo, "; metal: ", resource_metal)

func _get_target():
	var ret = null
	var retry = 5
	for _i in retry:
		if _next_target == "hq":
			ret = _get_hq()
		else:
			ret = _get_ally(_next_target)
		
		if ret != null:
			break

		await get_tree().process_frame
	
	if ret == null:
		printerr("Invalid target: ", _next_target)
		return null
	return ret

func _get_hq():
	return get_node("/root/game/hq")

func _get_ally(ally_name: String):
	# HACK: hard-coded path
	return get_node("/root/game/allys/" + ally_name)

func _deliver(u: Node, v: Node, resource: String, amount: int) -> bool:
	if u == null or v == null:
		printerr("Invalid deliverer target or sender.")
		return false

	if amount <= 0:
		printerr("Invalid amount: ", amount)
		return false

	if resource != "food" and resource != "ammo" and resource != "metal":
		printerr("Unknown resource: ", resource)
		return false

	var field_name := "resource_" + resource
	var u_resource = u.get(field_name)
	var v_resource = v.get(field_name)

	if u_resource < amount:
		printerr(u.name, " has not enough resource.")
		return false

	u.set(field_name, u_resource - amount)
	v.set(field_name, v_resource + amount)

	return true
