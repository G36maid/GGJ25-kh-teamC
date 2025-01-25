extends Node2D

@export var deliverer_scene: PackedScene
@export var ally_scene: PackedScene
@export var enemy_scene: PackedScene
@export var headquarter_scene: PackedScene
const LAN = 5
const DILIVERER_COUNT = 5
var deliverers := []
var deliver_index = 0
var enemy_start_spawning = false
var remain_enemy
var headquarter

enum State {
	BeforeStart,
	Start,
	End,
}

var state: State = State.BeforeStart

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass
	
func _start() -> void:
	remain_enemy = 10
	$start_button.hide()
	$enemy_timer.start()
	state = State.Start
	
	var hq_position = Vector2(
		get_viewport_rect().size.x / 4,
		get_viewport_rect().size.y * 0.9
	)
	for _i in DILIVERER_COUNT:
		var deliverer = deliverer_scene.instantiate()
		deliverer.position = hq_position
		deliverers.push_back(deliverer)
		$deliverers.add_child(deliverer)
	
	for i in LAN:
		var ally = ally_scene.instantiate()
		var y_size = get_viewport_rect().size.y
		ally.position = Vector2(
			get_x(i),
			randf_range(y_size * 0.5, y_size * 0.8)
		)
		ally.name = "ally" + str(i)
		$allys.add_child(ally)
		
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
		return
		
	$enemy_remain.text = """Enemy Remain: %d
Food: %d
Ammo: %d
Metal: %d
""" % [remain_enemy, headquarter.resource_food, 
	headquarter.resource_ammo, headquarter.resource_metal]


func _on_enemy_timer_timeout() -> void:
	if remain_enemy == 0:
		$enemy_timer.stop()
		return
	var enemy = enemy_scene.instantiate()
	enemy.position = Vector2(
		get_x(randi_range(0, LAN - 1)),
		10
	)
	$enemys.add_child(enemy)
	enemy_start_spawning = true
	remain_enemy -= 1
	
func send_command_to_deliverers(commands: Array) -> void:
	deliverers[deliver_index].set_commands(commands)
	deliver_index = (deliver_index + 1) % DILIVERER_COUNT
	
func get_x(lan: int) -> int:
	var lan_width = get_viewport_rect().size.x / 2 / LAN
	return lan_width * lan + lan_width / 2
