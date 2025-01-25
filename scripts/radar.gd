extends Node2D

@onready var raycast_2d: RayCast2D = $RayCast2D

func _ready() -> void:
	pass

func _process(delta: float) -> void:
	rotation += delta

func _physics_process(_delta: float) -> void:
	if raycast_2d.is_colliding():
		# TODO: try to call ally/hq/enemy 's method
		var obj = raycast_2d.get_collider().get_parent()
		if obj.has_method("on_radar_scanned"):
			obj.on_radar_scanned()
