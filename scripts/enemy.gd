extends Node2D


@onready var ally_parent = $/root/game/allys

var lan
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	print(lan+1)
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float):
	position.y += 5
