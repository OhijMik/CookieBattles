extends CharacterBody2D

var chase
var speed = 100
var closest_cookie
var hp = 100
var initial_hp = float(hp)
var damage = 33

@onready var anim = get_node("AnimationPlayer")
@onready var timer = get_node("AttackCooldown")


# Called when the node enters the scene tree for the first time.
func _ready():
	chase = false
	#global.milk_list.append(self)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var health_bar = get_node("HealthBar")
	health_bar.size.x = 100 * (hp/initial_hp)
	get_node("HealthText").text = str(hp)


func _physics_process(_delta):
	if global.game_state == "battle":
		if global.cookie_list == []:
			get_tree().change_scene_to_file("res://Main_Scenes/end_scene.tscn")
			global.game_state = "prepare"
		
		elif closest_cookie != null and closest_cookie.hp <= 0:
			global.cookie_list.erase(closest_cookie)
			if global.cookie_list.is_empty():
				get_tree().change_scene_to_file("res://Main_Scenes/end_scene.tscn")
			else:
				closest_cookie.get_node("CollisionShape2D").set_disabled(true)
				closest_cookie.visible = false
				chase = true
				closest_cookie = global.cookie_list[0]
			
		elif closest_cookie == null:
			closest_cookie = global.cookie_list[0]
			chase = true

		if chase and closest_cookie != null:
			for i in global.cookie_list:
				if position.distance_to(i.position) <= position.distance_to(closest_cookie.position):
					closest_cookie = i
			var direction = (closest_cookie.position - position).normalized()
			velocity.x = direction.x * speed
			velocity.y = direction.y * speed
			look_at(closest_cookie.position)
			rotate(-PI/2)
			move_and_slide()


func _on_range_body_entered(body):
	if body in global.cookie_list and global.game_state == "battle":
		chase = false
		timer.start()


func _on_range_body_exited(body):
	if global.game_state == "battle":
		chase = true
		timer.stop()


func _on_attack_cooldown_timeout():
	if global.game_state == "battle":
		anim.play("Attack")
		closest_cookie.hp -= damage
