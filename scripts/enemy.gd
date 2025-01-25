extends Node2D

const max_health = 100
var health 

@onready var ally_parent = $/root/game/allys

var lan
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	health = 100
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float):
	
	
	position.y += 5
