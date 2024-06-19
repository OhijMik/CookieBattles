extends CharacterBody2D

var chase
var speed = 100
var closest_enemy
var hp = 100
var initial_hp = float(hp)


@onready var anim = get_node("AnimationPlayer")
@onready var cooldown = get_node("AttackCooldown")

var draggable = false
var is_inside_dropable = false
var body_ref
var prev_body_ref
var offset : Vector2
var initial_pos : Vector2
var milk_in_range = []

var price = 3

var projectile = preload("res://Projectile/cookie_projectile.tscn")
var projectile_speed = 200


func _ready():
	chase = false
	global.cookie_list.append(self)


func _process(delta):
	get_node("HealthText").text = str(hp)
	var health_bar = get_node("HealthBar")
	health_bar.size.x = 100 * (hp/initial_hp)
	
	# When dragging the cookie
	if draggable and global.game_state == "prepare":
		if Input.is_action_just_pressed("click"):
			initial_pos = global_position
			offset = get_global_mouse_position() - global_position
			global.is_dragging = true
		if Input.is_action_pressed("click"):
			global_position = get_global_mouse_position() - offset
		elif Input.is_action_just_released("click"):
			global.is_dragging = false
			var tween = get_tree().create_tween()
			if is_inside_dropable and not body_ref.is_occupied:
				prev_body_ref.is_occupied = false
				body_ref.is_occupied = true
				prev_body_ref = body_ref
				initial_pos = position
				tween.tween_property(self, "position", body_ref.position, 0.2).set_ease(Tween.EASE_OUT)
			else:
				tween.tween_property(self, "global_position", initial_pos, 0.2).set_ease(Tween.EASE_OUT)


func _physics_process(_delta):
	if not global.paused:
		cooldown.set_paused(false)
		if global.game_state == "battle":
			milk_in_range = get_node("Range").get_overlapping_bodies()
			
			closest_enemy = global.milk_list[0]
			for i in global.milk_list:
				if position.distance_to(i.position) <= position.distance_to(closest_enemy.position):
					closest_enemy = i

			if milk_in_range.is_empty():
				chase = true
				cooldown.stop()
			
			if not milk_in_range.is_empty():
				chase = false
				var direction = (closest_enemy.position - position).normalized()
				look_at(closest_enemy.position)
				rotate(PI/2)
				if cooldown.is_stopped():
					var projectile_temp = projectile.instantiate()
					projectile_temp.position = position
					projectile_temp.name = "Projectile"
					projectile_temp.set_enemy(closest_enemy)
					get_node("../../Projectile").call_deferred("add_child", projectile_temp)
					cooldown.start()
			
			# when chasing
			if chase and closest_enemy != null:
				var direction = (closest_enemy.position - position).normalized()
				velocity.x = direction.x * speed
				velocity.y = direction.y * speed
				look_at(closest_enemy.position)
				rotate(PI/2)
				move_and_slide()
	else:
		cooldown.set_paused(true)


func _on_attack_cooldown_timeout():
	if global.game_state == "battle":
		anim.play("Attack")
		var projectile_temp = projectile.instantiate()
		projectile_temp.position = position
		projectile_temp.set_enemy(closest_enemy)
		get_node("../../Projectile").call_deferred("add_child", projectile_temp)





# Drag and dropping the cookie
func _on_area_cookie_mouse_entered():
	if not global.is_dragging and global.game_state == "prepare":
		draggable = true
		scale = Vector2(1.05, 1.05)


func _on_area_cookie_mouse_exited():
	if not global.is_dragging and global.game_state == "prepare":
		draggable = false
		scale = Vector2(1, 1)


func _on_area_cookie_body_entered(body):
	if body.is_in_group("dropable") and global.game_state == "prepare":
		is_inside_dropable = true
		body.modulate = Color(Color.BLACK, 1)
		if body_ref != null and not body_ref.is_occupied:
			body_ref.is_occupied = false
		body_ref = body
		
		if prev_body_ref == null:
			prev_body_ref = body_ref


func _on_area_cookie_body_exited(body):
	if body.is_in_group("dropable") and global.game_state == "prepare":
		is_inside_dropable = false
		body.modulate = Color(Color.BLACK, 0.7)
