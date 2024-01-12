extends StaticBody2D

var sellable = false
var selling_cookie


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_released("click") and global.game_state == "prepare" and sellable:
		global.cookie_list.erase(selling_cookie)
		selling_cookie.queue_free()
		sellable = false
		global.gold += selling_cookie.price - 1


func _on_area_2d_body_entered(body):
	sellable = true
	selling_cookie = body
