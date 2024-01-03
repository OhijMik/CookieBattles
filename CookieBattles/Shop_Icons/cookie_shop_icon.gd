extends Node2D

var cookie = preload("res://Cookies/cookie.tscn")
var buyable = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if buyable and Input.is_action_just_pressed("click"):
		var cookie_temp = cookie.instantiate()
		cookie_temp.position = Vector2(0,0)
		get_node("../Cookies").add_child(cookie_temp)
		print(cookie_temp.get_path())
		buyable = false
		self.queue_free()


func _on_area_2d_mouse_entered():
	scale = Vector2(1.05, 1.05)
	buyable = true


func _on_area_2d_mouse_exited():
	scale = Vector2(1, 1)
	buyable = false
