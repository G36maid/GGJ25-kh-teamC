extends Node2D

@onready var raycast =  $Area2D/CollisionShape2D/Sprite2D/RayCast2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if(raycast.is_colliding()):
		print("has enemy at  front")
	pass
