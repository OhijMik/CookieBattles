extends Node2D

var timer
var milk = preload("res://Milks/milk.tscn")
var saved_cookies = {}

var fighter_cookie_shop_icon = preload("res://Shop_Icons/fighter_cookie_shop_icon.tscn")
var tank_cookie_shop_icon = preload("res://Shop_Icons/tank_cookie_shop_icon.tscn")
var vampire_cookie_shop_icon = preload("res://Shop_Icons/vampire_cookie_shop_icon.tscn")
var puff_cookie_shop_icon = preload("res://Shop_Icons/puff_cookie_shop_icon.tscn")
var range_cookie_shop_icon = preload("res://Shop_Icons/range_cookie_shop_icon.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	timer = get_node("Timer/Timer")
	timer.start()
	_random_shop_generator()
	
	var milk_pos = [Vector2(430, 250), Vector2(1300, 250)]
	for i in milk_pos:
		var milk_temp = milk.instantiate()
		milk_temp.position = i
		get_node("Milks").add_child(milk_temp)
		global.milk_list.append(milk_temp)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	get_node("Gold").text = "Gold: " + str(global.gold)
	get_node("Round").text = "Round " + str(global.round)
	
	# Timer
	if not timer.is_stopped():
		get_node("Timer/TimerText").text = str(global.game_state) + ": " + str(round(timer.get_time_left()))
	
	if global.milk_list.is_empty() and global.game_state == "battle":
		global.game_state = "conclusion"
		timer.start(5)


func _on_timer_timeout():
	if global.game_state == "prepare":
		global.game_state = "battle"
		# Save the initial position of the cookies
		for i in global.cookie_list:
			i.position = i.initial_pos
			saved_cookies[i] = i.position
		
		# Disable all platforms
		for i in get_tree().get_nodes_in_group("dropable"):
			i.get_node("CollisionShape2D").disabled = true
		timer.start(25)
	elif global.game_state == "battle":
		global.game_state = "conclusion"
		timer.start(5)
	elif global.game_state == "conclusion":
		global.game_state = "prepare"
		global.round += 1
		scene_reset()
		timer.start(5)


func scene_reset():
	# Spawns the milk enemies
	if global.round == 2:
		var milk_pos = [Vector2(430, 250), Vector2(1300, 250), Vector2(730, 250), Vector2(1000, 250)]
		for i in milk_pos:
			var milk_temp = milk.instantiate()
			milk_temp.position = i
			get_node("Milks").add_child(milk_temp)
			global.milk_list.append(milk_temp)
	elif global.round == 3:
		var milk_pos = [Vector2(430, 250), Vector2(1300, 250), Vector2(630, 250), 
						Vector2(1100, 250), Vector2(830, 200), Vector2(900, 200)]
		for i in milk_pos:
			var milk_temp = milk.instantiate()
			milk_temp.position = i
			milk_temp.damage = 35
			get_node("Milks").add_child(milk_temp)
			global.milk_list.append(milk_temp)
	elif global.round == 4:
		var milk_pos = [Vector2(430, 250), Vector2(1300, 250), Vector2(630, 250), 
						Vector2(1100, 250), Vector2(830, 200), Vector2(900, 200)]
		for i in milk_pos:
			var milk_temp = milk.instantiate()
			milk_temp.position = i
			milk_temp.hp = 200
			milk_temp.damage = 35
			milk_temp.initial_hp = float(milk_temp.hp)
			get_node("Milks").add_child(milk_temp)
			global.milk_list.append(milk_temp)
	elif global.round == 5:
		var milk_pos = [Vector2(900, 200)]
		for i in milk_pos:
			var milk_temp = milk.instantiate()
			milk_temp.position = i
			milk_temp.hp = 1000
			milk_temp.damage = 100
			milk_temp.initial_hp = float(milk_temp.hp)
			get_node("Milks").add_child(milk_temp)
			global.milk_list.append(milk_temp)
	elif global.round == 6:
		get_tree().change_scene_to_file("res://Main_Scenes/win_scene.tscn")
	
	# Resets the cookies
	for i in saved_cookies:
		i.position = saved_cookies[i]
		i.get_node("CollisionShape2D").set_disabled(false)
		i.visible = true
		i.hp = i.initial_hp
		i.rotation = 0


func _on_reroll_button_pressed():
	if global.gold >= 2:
		global.gold -= 2
		
		# Removing the current shop
		for n in get_node("Shop").get_children():
			get_node("Shop").remove_child(n)
			n.queue_free()
		
		_random_shop_generator()
		
	
	
func _random_shop_generator():
	# Spawning the icons
	for x in range(560, 1233, 168):
		var rng = RandomNumberGenerator.new()
		var randInt = rng.randi_range(0, 4)
		if randInt == 0:
			var fighter_cookie_temp = fighter_cookie_shop_icon.instantiate()
			fighter_cookie_temp.position = Vector2(x,912)
			get_node("Shop").add_child(fighter_cookie_temp)
		elif randInt == 1:
			var tank_cookie_temp = tank_cookie_shop_icon.instantiate()
			tank_cookie_temp.position = Vector2(x,912)
			get_node("Shop").add_child(tank_cookie_temp)
		elif randInt == 2:
			var vampire_cookie_temp = vampire_cookie_shop_icon.instantiate()
			vampire_cookie_temp.position = Vector2(x,912)
			get_node("Shop").add_child(vampire_cookie_temp)
		elif randInt == 3:
			var puff_cookie_temp = puff_cookie_shop_icon.instantiate()
			puff_cookie_temp.position = Vector2(x,912)
			get_node("Shop").add_child(puff_cookie_temp)
		elif randInt == 4:
			var range_cookie_temp = range_cookie_shop_icon.instantiate()
			range_cookie_temp.position = Vector2(x,912)
			get_node("Shop").add_child(range_cookie_temp)
