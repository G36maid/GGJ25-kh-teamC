extends Node2D

@export var deliverer_scene: PackedScene
@export var ally_scene: PackedScene
@export var enemy_scene: PackedScene
@export var headquarter_scene: PackedScene
const LAN = 5
const DILIVERER_COUNT = 5
var deliverers := []
var deliver_index = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$EnemyTimer.start()
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
		$allys.add_child(ally)
		
	var hq = headquarter_scene.instantiate()
	hq.position = hq_position
	add_child(hq)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_enemy_timer_timeout() -> void:
	var enemy = enemy_scene.instantiate()
	enemy.position = Vector2(
		get_x(randi_range(0, LAN - 1)),
		10
	)
	print(enemy.position)
	$enemys.add_child(enemy)
	
	
func send_command_to_deliverers(commands: Array) -> void:
	deliverers[deliver_index].set_commands(commands)
	deliver_index = (deliver_index + 1) % DILIVERER_COUNT
	
func get_x(lan: int) -> int:
	var lan_width = get_viewport_rect().size.x / 2 / LAN
	return lan_width * lan + lan_width / 2
	
