extends CharacterBody2D

var chase
var enemy_list = []
var speed = 100
var closest_enemy
var hp = 100
var damage = 34

@onready var anim = get_node("AnimationPlayer")
@onready var timer = get_node("AttackCooldown")

var draggable = false
var is_inside_dropable = false
var body_ref
var offset : Vector2
var initialPos : Vector2


# Called when the node enters the scene tree for the first time.
func _ready():
	chase = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if draggable:
		if Input.is_action_just_pressed("click"):
			initialPos = global_position
			offset = get_global_mouse_position() - global_position
			global.is_dragging = true
		if Input.is_action_pressed("click"):
			global_position = get_global_mouse_position() - offset
		elif Input.is_action_just_released("click"):
			global.is_dragging = false
			var tween = get_tree().create_tween()
			if is_inside_dropable:
				tween.tween_property(self, "position", body_ref.position, 0.2).set_ease(Tween.EASE_OUT)
			else:
				tween.tween_property(self, "global_position", initialPos, 0.2).set_ease(Tween.EASE_OUT)

func _physics_process(_delta):
	if global.game_state == "battle":
		if closest_enemy != null and closest_enemy.hp <= 0:
			print(enemy_list)
			enemy_list.erase(closest_enemy)
			print(enemy_list)
			if enemy_list.is_empty():
				chase = false
				get_tree().change_scene_to_file("res://end_scene.tscn")
			else:
				closest_enemy.queue_free()
				chase = true
				closest_enemy = enemy_list[0]
		
		if chase and closest_enemy != null:
			for i in enemy_list:
				if position.distance_to(i.position) <= position.distance_to(closest_enemy.position):
					closest_enemy = i

			var direction = (closest_enemy.position - position).normalized()
			velocity.x = direction.x * speed
			velocity.y = direction.y * speed
			look_at(closest_enemy.position)
			rotate(PI/2)
			move_and_slide()
	
	var health_bar = get_node("HealthBar")
	health_bar.size.x = hp


func _on_enemy_detection_body_entered(body):
	if "Milk" in body.name:
		print(body)
		chase = true
		enemy_list.append(body)
		closest_enemy = body


func _on_range_body_entered(body):
	if body in enemy_list:
		chase = false
		timer.start()


func _on_range_body_exited(body):
	chase = true
	timer.stop()


func _on_attack_cooldown_timeout():
	anim.play("Attack")
	closest_enemy.hp -= damage




# Drag and dropping the cookie
func _on_area_cookie_mouse_entered():
	if not global.is_dragging:
		draggable = true
		scale = Vector2(1.05, 1.05)


func _on_area_cookie_mouse_exited():
	if not global.is_dragging:
		draggable = false
		scale = Vector2(1, 1)


func _on_area_cookie_body_entered(body):
	if body.is_in_group("dropable"):
		is_inside_dropable = true
		body.modulate = Color(Color.BLACK, 1)
		body_ref = body


func _on_area_cookie_body_exited(body):
	if body.is_in_group("dropable"):
		is_inside_dropable = false
		body.modulate = Color(Color.BLACK, 0.7)
