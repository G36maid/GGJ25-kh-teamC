extends Node2D

const max_health = 100
var health 


@onready var raycast =  $Area2D/CollisionShape2D/Sprite2D/RayCast2D

var resource_food := 0
var resource_ammo := 0
var resource_metal := 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	health = 100;
	pass # Replace with function body.
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if (health < max_health && resource_food > 0 ):
		health += 1
		resource_food -= 1
	
	if(resource_ammo > 0 and raycast.is_colliding() ):
		var target = raycast.get_collider()
		print(target)
	pass
