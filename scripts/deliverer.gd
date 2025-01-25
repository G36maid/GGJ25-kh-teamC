class_name Deliverer
extends Node2D

@export var speed: int = 10

enum State {
	Idle,
	Duty,
}
var state: State = State.Idle

var resource_food: int = 0
var resource_ammo: int = 0
var resource_metal: int = 0

var _commands: Array = []

func _ready() -> void:
	set_commands([
		["grab", "food", "10"],
		["goto", "ally1"],
		["drop", "food", "10"],
		["grab", "ammo", "10"],
		["goto", "ally2"],
		["drop", "ammo", "10"],
		["grab", "metal", "10"],
		["goto", "hq"],
		["drop", "metal", "10"], # TODO: can I drop resource to hq?
	])

func set_commands(commands: Array) -> bool:
	"""
	set commands that will be executed by deliverer.
	"""
	
	if state != State.Idle:
		printerr("Cannot set commands while deliverer is not idle.")
		return false

	_commands = commands
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
			return exec_drop(command)
		"grab":
			return exec_grab(command)

	printerr("Unknown command: ", command)
	return State.Idle

func exec_goto(command: PackedStringArray) -> State:
	var target: String = command[1]
	# TODO: convert target to pos
	var target_pos := position
	match target:
		"ally1":
			target_pos = Vector2(100, 100)
		"ally2":
			target_pos = Vector2(200, 200)
		"hq":
			target_pos = Vector2(0, 0)
		_:
			printerr("Unknown target: ", target)
			return State.Idle

	while (position - target_pos).length_squared() > 0.01:
		# TODO: inject params?
		var delta := get_process_delta_time() * speed
		position = position.move_toward(target_pos, delta)
		await get_tree().process_frame
	
	if target == "hq":
		return State.Idle
	return State.Duty

func exec_drop(command: PackedStringArray) -> State:
	var resource: String = command[1]
	var amount: int = int(command[2])
	
	if resource == "food":
		print("Deliverer dropped ", amount, " food.")
		resource_food += amount
	elif resource == "ammo":
		print("Deliverer dropped ", amount, " ammo.")
		resource_ammo += amount
	elif resource == "metal":
		print("Deliverer dropped ", amount, " metal.")
		resource_metal += amount
	
	_debug_show_resource()

	return State.Duty

func exec_grab(command: PackedStringArray) -> State:
	var resource: String = command[1]
	var amount: int = int(command[2])

	# TODO: exception handling

	if resource == "food":
		print("Deliverer grabbed ", amount, " food.")
		resource_food -= amount
	elif resource == "ammo":
		print("Deliverer grabbed ", amount, " ammo.")
		resource_ammo -= amount
	elif resource == "metal":
		print("Deliverer grabbed ", amount, " metal.")
		resource_metal -= amount

	_debug_show_resource()

	return State.Duty

func _debug_show_resource():
	print("food: ", resource_food, "; ammo: ", resource_ammo, "; metal: ", resource_metal)
