extends StaticBody2D

var is_occupied = false


# Called when the node enters the scene tree for the first time.
func _ready():
	modulate = Color(Color.BLACK, 0.7)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if global.is_dragging:
		visible = true
	else:
		visible = false
	
	if is_occupied:
		print(self)
	
	if global.game_state == "prepare":
		get_node("CollisionShape2D").disabled = false
