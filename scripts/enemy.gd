extends Node2D


@export var speed: float = 10

const max_health = 100
var health

@onready var raycast = $Area2D/CollisionShape2D/Sprite2D/RayCast2D
@onready var sprite = $Area2D/CollisionShape2D/Sprite2D

var can_be_scanned := true
var lan

func _ready() -> void:
	health = 100

func _process(delta: float):
	position.y += delta * speed

func _on_timer_timeout() -> void:
	if raycast.is_colliding():
		print("inpact: " + str(health))
		var target = raycast.get_collider()
		target.get_parent().get_damage(health)
		queue_free()
		
func get_damage(damage: int):
	health -= damage
	if health <= 0:
		queue_free()

func on_radar_scanned():
	if not can_be_scanned:
		return
	can_be_scanned = false
	get_tree().create_timer(3.0).timeout.connect(func(): can_be_scanned = true)

	var s := sprite.duplicate() as Sprite2D
	s.visible = true
	s.position = position
	get_tree().create_timer(1).timeout.connect(func(): s.queue_free())
	get_tree().get_root().add_child(s)
