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
	
	$Label.text = """Food: %d
Ammo:%d
Metal:%d
""" % [resource_food, resource_ammo, resource_metal]

	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if (health < max_health && resource_food > 0):
		health += 1
		resource_food -= 1
	
	if (resource_ammo > 0 and raycast.is_colliding()):
		var target = raycast.get_collider()
		print(target)


func _on_timer_timeout() -> void:

	if (health < max_health && resource_food > 10 ):
		health += 10
		resource_food -= 10
	if (health < max_health && resource_food > 0 ):
		var temp = max(max_health - health , resource_food)
		health += temp
		resource_food -= temp
	if( resource_ammo >=0 and raycast.is_colliding() ):
		var target = raycast.get_collider()
		target.get_parent().get_damage(10)
		resource_ammo -= 1

func get_damage(damage: int):
	health -= damage
	if health <= 0 :
		print("gameover")

func on_radar_scanned():
	$Label.text = """Food: %d
Ammo:%d
Metal:%d
""" % [resource_food, resource_ammo, resource_metal]
