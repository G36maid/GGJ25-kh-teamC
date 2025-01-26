extends Node2D

@export var deliverer_scene: PackedScene
@export var ally_scene: PackedScene
@export var enemy_scene: PackedScene
@export var headquarter_scene: PackedScene
@export var radar_scene: PackedScene
@onready var radar_parent = $Background/RadarMask

const LAN = 5
const DILIVERER_COUNT = 5
const PANEL_WIDTH = 1100
const PADDING = 70
const ALLY_MIN_Y = 200
const ALLY_MAX_Y = 300
const HQ_Y = 450

var deliverers := []
var enemy_start_spawning = false
var remain_enemy := 50
var remain_deliverers_count = 0
var headquarter
var pass_to_enemy_ally_y := []

enum State {
	BeforeStart,
	Start,
	End,
}

var state: State = State.BeforeStart

func _ready():
	$beforestart.visible = true

func _start() -> void:
	$beforestart.visible = false
	$start_button.hide()
	$enemy_timer.start()
	$txt_input.show()

	$txt_input/sender.text_changed.connect($Background/Alien0.shake)
	$txt_input/sender.text_changed.connect($Background/Alien1.shake)

	state = State.Start
	
	var hq_position = Vector2(-440, HQ_Y)
	for _i in DILIVERER_COUNT:
		var deliverer = deliverer_scene.instantiate()
		deliverer.position = hq_position
		deliverers.push_back(deliverer)
		$deliverers.add_child(deliverer)
	
	for i in LAN:
		var ally = ally_scene.instantiate()
		ally.position = Vector2(
			get_x(i),
			randf_range(ALLY_MIN_Y, ALLY_MAX_Y)
		)
		ally.name = "ally" + str(i)
		#pass_to_enemy_ally_y[i] = ally.y
		$allys.add_child(ally)
	
	var radar := radar_scene.instantiate()
	radar_parent.add_child(radar)
	radar.global_position = Vector2(-425, 450)

	headquarter = headquarter_scene.instantiate()
	headquarter.name = "hq"
	headquarter.position = hq_position
	add_child(headquarter)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if state != State.Start:
		return
		
	if $enemys.get_children().size() == 0 and enemy_start_spawning:
		state = State.End
		$win_text.show()
		$txt_input.hide()
		return

	if $allys.get_child_count() > 0:
		for _dead_ally in $allys.get_children():
			if _dead_ally.health <= 0:
				state = State.End
				$lose_text.show()
				return
	$enemy_remain.text = """Enemy Remain: %d
Food:%d
Ammo:%d
Metal:%d
""" % [remain_enemy, headquarter.resource_food,
	headquarter.resource_ammo, headquarter.resource_metal]
	
	remain_deliverers_count = 0
	for d in deliverers:
		if d.state == Deliverer.State.Idle:
			remain_deliverers_count += 1
	$remain_deliverers.get_child(0).text = str(remain_deliverers_count)

func _on_enemy_timer_timeout() -> void:
	if remain_enemy == 0:
		$enemy_timer.stop()
		return
	var enemy = enemy_scene.instantiate()
	enemy.lan = randi_range(0, LAN - 1)
	enemy.position = Vector2(get_x(enemy.lan), -600)
	$enemys.add_child(enemy)
	enemy_start_spawning = true
	remain_enemy -= 1
	
func send_commands_to_deliverer(commands: Array) -> bool:
	for d in deliverers:
		if d.set_commands(commands):
			return true
	return false
	
func get_x(lan: int) -> int:
	var lan_width = (PANEL_WIDTH - PADDING * 2) / LAN
	return lan_width * lan + lan_width / 2 + PADDING - 960
