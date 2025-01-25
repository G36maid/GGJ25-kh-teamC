extends Sprite2D

@export var shake_offset: Vector2 = Vector2(0, 10)
var original_position: Vector2 = Vector2(0, 0)

var _should_shake: int = 0

func _ready() -> void:
	original_position = position
	start_shake_present()

func shake() -> void:
	if randf() > 0.5:
		return
	_should_shake = 1

func start_shake_present():
	while true:
		if _should_shake > 0:
			_should_shake -= 1
			if (original_position - position).length_squared() < 0.1:
				position = position + shake_offset + Vector2(randf_range(-1, 1), randf_range(-1, 1))
			else:
				position = original_position
		
		await get_tree().create_timer(0.1).timeout
