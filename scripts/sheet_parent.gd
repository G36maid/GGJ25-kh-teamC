extends Node2D

var show_sheet: bool=false
var dist: float=0
var delta_dist: float = 25
var max_dist: float=770

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if(show_sheet && dist<max_dist):
		self.move_local_y(delta_dist)
		dist+=delta_dist
	elif(!show_sheet && dist>0):
		self.move_local_y(-delta_dist)
		dist-=delta_dist

func _on_sheet_mouse_entered() -> void:
	show_sheet = true

func _on_sheet_mouse_exited() -> void:
	show_sheet = false

func _on_label_mouse_entered() -> void:
	show_sheet = true

func _on_label_mouse_exited() -> void:
	show_sheet = false
