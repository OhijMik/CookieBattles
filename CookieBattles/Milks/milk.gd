extends CharacterBody2D

var chase
var speed = 100
var cookie_list = []
var closest_cookie
var hp = 100
var damage = 33

@onready var anim = get_node("AnimationPlayer")
@onready var timer = get_node("AttackCooldown")


# Called when the node enters the scene tree for the first time.
func _ready():
	chase = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _physics_process(_delta):
	if global.game_state == "battle":
		if closest_cookie != null and closest_cookie.hp <= 0:
			cookie_list.erase(closest_cookie)
			if cookie_list.is_empty():
				get_tree().change_scene_to_file("res://Main_Scenes/end_scene.tscn")
			else:
				closest_cookie.queue_free()
				chase = true
				closest_cookie = cookie_list[0]
			
		
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
	
	var health_bar = get_node("HealthBar")
	health_bar.size.x = hp


func _on_cookie_detection_body_entered(body):
	if "Cookie" in body.name:
		chase = true
		cookie_list.append(body)
		closest_cookie = body


func _on_range_body_entered(body):
	if body in cookie_list:
		chase = false
		timer.start()


func _on_range_body_exited(body):
	chase = true
	timer.stop()


func _on_attack_cooldown_timeout():
	anim.play("Attack")
	closest_cookie.hp -= damage
