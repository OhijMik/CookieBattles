extends CharacterBody2D

var chase
var cookie
var speed = 100


# Called when the node enters the scene tree for the first time.
func _ready():
	chase = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _physics_process(_delta):
	if chase:
		var direction = (cookie.position - position).normalized()
		velocity.x = direction.x * speed
		velocity.y = direction.y * speed
		move_and_slide()


func _on_cookie_detection_body_entered(body):
	#print(body)
	if body.name == "Cookie":
		chase = true
		cookie = body


func _on_range_body_entered(body):
	if body == cookie:
		chase = false


