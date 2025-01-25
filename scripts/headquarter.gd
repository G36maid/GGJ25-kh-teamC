extends Node2D

var resource_food: int = 0
var resource_ammo: int = 0
var resource_metal: int = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$hq_timer.start()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_hq_timer_timeout() -> void:
	resource_food += 1
	resource_ammo += 1
	resource_metal += 1
