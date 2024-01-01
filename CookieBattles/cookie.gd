extends CharacterBody2D

var chase
var enemy_milk
var speed = 100

@onready var anim = get_node("AnimationPlayer")


# Called when the node enters the scene tree for the first time.
func _ready():
	chase = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _physics_process(_delta):
	if chase:
		var direction = (enemy_milk.position - position).normalized()
		velocity.x = direction.x * speed
		velocity.y = direction.y * speed
		look_at(enemy_milk.position)
		rotate(PI/2)
		move_and_slide()


func _on_enemy_detection_body_entered(body):
	if body.name == "Milk":
		chase = true
		print(body)
		enemy_milk = body


func _on_range_body_entered(body):
	if body == enemy_milk:
		chase = false
		anim.play("Attack")
