extends Node2D

@onready var raycast_2d: RayCast2D = $RayCast2D

func _ready() -> void:
	pass

func _process(delta: float) -> void:
	raycast_2d.rotation += delta

func _physics_process(_delta: float) -> void:
	if raycast_2d.is_colliding():
		# TODO: try to call ally/hq/enemy 's method
		pass
