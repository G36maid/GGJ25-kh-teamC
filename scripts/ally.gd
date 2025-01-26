extends Node2D

const max_health = 100
var health

@onready var raycast = $Area2D/CollisionShape2D/Sprite2D/RayCast2D

var resource_food := 0
var resource_ammo := 100
var resource_metal := 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	health = 100;

	start_float_animation()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if (health < max_health && resource_food > 0):
		health += 1
		resource_food -= 1
	
	if (resource_ammo > 0 and raycast.is_colliding()):
		var target = raycast.get_collider()
		print(target)


func _on_timer_timeout() -> void:

	if (health < max_health && resource_food > 10):
		health += 10
		resource_food -= 10
	if (health < max_health && resource_food > 0):
		var temp = max(max_health - health, resource_food)
		health += temp
		resource_food -= temp
	if (resource_ammo >= 0 and raycast.is_colliding()):
		var target = raycast.get_collider()
		target.get_parent().get_damage(10)
		resource_ammo -= 1

func get_damage(damage: int):
	health -= damage

	# TODO: handle ally death
	if health <= 0:
		print("gameover")

func on_radar_scanned():
	$ResourceLabel/VBoxContainer/FoodLabel/Label.text = str(resource_food)
	$ResourceLabel/VBoxContainer/AmmonLabel/Label.text = str(resource_ammo)
	$ResourceLabel/VBoxContainer/MetalLabel/Label.text = str(resource_metal)

func start_float_animation():
	var start := position
	var end := position - Vector2(0, 100)
	var speed := 10

	while true:
		await _move_towards(end + Vector2(0, randf_range(-5, 5)), speed + randf_range(-3, 3))
		await _move_towards(start + Vector2(0, randf_range(-5, 5)), speed + randf_range(-3, 3))

func _move_towards(target: Vector2, speed: float) -> void:
	speed /= 25
	while (position - target).length_squared() > 9:
		position = position.lerp(target, get_process_delta_time() * speed)
		await get_tree().process_frame
