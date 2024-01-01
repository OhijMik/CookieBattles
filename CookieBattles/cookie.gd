extends CharacterBody2D

var chase
var enemy_list = []
var speed = 100
var closest_enemy

@onready var anim = get_node("AnimationPlayer")


# Called when the node enters the scene tree for the first time.
func _ready():
	chase = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _physics_process(_delta):
	if chase:
		for i in enemy_list:
			if position.distance_to(i.position) <= position.distance_to(closest_enemy.position):
				closest_enemy = i

		var direction = (closest_enemy.position - position).normalized()
		velocity.x = direction.x * speed
		velocity.y = direction.y * speed
		look_at(closest_enemy.position)
		rotate(PI/2)
		move_and_slide()


func _on_enemy_detection_body_entered(body):
	if "Milk" in body.name:
		chase = true
		enemy_list.append(body)
		closest_enemy = body


func _on_enemy_detection_body_exited(body):
	enemy_list.erase(body)
	chase = true
	if enemy_list.is_empty():
		get_tree().change_scene_to_file("res://end_scene.tscn")
	else:
		closest_enemy = enemy_list[0]


func _on_range_body_entered(body):
	if body in enemy_list:
		chase = false
		anim.play("Attack")


func _on_range_body_exited(body):
	anim.stop()
