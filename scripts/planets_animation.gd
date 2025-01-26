extends Node2D

var angle_speed = []
	
var astroids = [] 
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	astroids = self.get_children()
	for i in astroids.size():
		angle_speed.append(randf_range(0.5,1.5))
	for ast in astroids:
		if ast != null: 	
			ast.offset = Vector2(8000+randi_range(-200,200),0)  
			ast.position = Vector2 (-1300,1000)
			ast.rotation = randf_range(0,360)
		
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	for i in astroids.size():
		astroids[i].rotation +=	angle_speed[i] * delta
