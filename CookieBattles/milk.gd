extends CharacterBody2D

var chase
var speed = 100
var cookie_list = []
var closest_cookie

@onready var anim = get_node("AnimationPlayer")


# Called when the node enters the scene tree for the first time.
func _ready():
	chase = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _physics_process(_delta):
	if chase:
		for i in cookie_list:
			if position.distance_to(i.position) <= position.distance_to(closest_cookie.position):
				closest_cookie = i
		
		var direction = (closest_cookie.position - position).normalized()
		velocity.x = direction.x * speed
		velocity.y = direction.y * speed
		look_at(closest_cookie.position)
		rotate(-PI/2)
		move_and_slide()


func _on_cookie_detection_body_entered(body):
	if "Cookie" in body.name:
		chase = true
		cookie_list.append(body)
		closest_cookie = body


func _on_cookie_detection_body_exited(body):
	cookie_list.erase(body)
	chase = true
	if cookie_list.is_empty():
		get_tree().change_scene_to_file("res://end_scene.tscn")
	else:
		closest_cookie = cookie_list[0]


func _on_range_body_entered(body):
	if body in cookie_list:
		chase = false
		anim.play("Attack")


func _on_range_body_exited(body):
	chase = true
	anim.stop()

