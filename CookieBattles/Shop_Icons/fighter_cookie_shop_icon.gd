extends Node2D

var cookie = preload("res://Cookies/fighter_cookie.tscn")
var buyable = false
var loop_break = false
var price = 1
var platform_num = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if buyable and Input.is_action_just_pressed("click") and global.game_state == "prepare":
		var cookie_temp = cookie.instantiate()
		
		if global.cookie_list == [] or not get_node("../../Platforms/Platform").is_occupied:
			global.gold -= price
			get_node("../../Platforms/Platform").is_occupied = true
			cookie_temp.position = Vector2(384,504)
			cookie_temp.initial_pos = Vector2(384,504)
			get_node("../../Cookies").add_child(cookie_temp)
			self.queue_free()
		else:
			for y in range(504, 761, 128):
				for x in range(384, 1409, 128):
					platform_num += 1
					for cookie in global.cookie_list:
						if cookie.position == Vector2(x,y):
							loop_break = false
							break
						else:
							loop_break = true
							continue
					if loop_break:
						global.gold -= price
						get_node("../../Platforms/Platform" + str(platform_num)).is_occupied = true
						cookie_temp.position = Vector2(x,y)
						cookie_temp.initial_pos = Vector2(x,y)
						get_node("../../Cookies").add_child(cookie_temp)
						self.queue_free()
						break
				if loop_break: break


func _on_area_2d_mouse_entered():
	scale = Vector2(1.05, 1.05)
	if global.gold >= price:
		buyable = true


func _on_area_2d_mouse_exited():
	scale = Vector2(1, 1)
	buyable = false

