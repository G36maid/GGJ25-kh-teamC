extends Node2D

const max_health = 100
var health 

@onready var raycast =  $Area2D/CollisionShape2D/Sprite2D/RayCast2D

var lan
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	health = 100
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float):
	position.y += 5

func _on_timer_timeout() -> void:
	if raycast.is_colliding():
		print("inpact: "+ str(health))
		var target = raycast.get_collider()
		target.get_parent().get_damage(health)
		queue_free()
		
func get_damage(damage: int):
	health -= damage
	if health <= 0 :
		#print("game over")
		queue_free()
