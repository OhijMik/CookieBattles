extends CharacterBody2D

var damage = 40
var projectile_speed = 600
var closest_enemy

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _physics_process(_delta):
	if closest_enemy != null:
		var direction = (closest_enemy.position - position).normalized()
		velocity.x = direction.x * projectile_speed
		velocity.y = direction.y * projectile_speed
		move_and_slide()


func set_enemy(body):
	closest_enemy = body


func _on_area_2d_body_entered(body):
	if body in global.milk_list and global.game_state == "battle":
		body.hp -= damage
		self.queue_free()
