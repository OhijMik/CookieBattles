extends Node2D

var timer
var milk = preload("res://Milks/milk.tscn")
var saved_cookies = {}

var fighter_cookie_shop_icon = preload("res://Shop_Icons/fighter_cookie_shop_icon.tscn")
var tank_cookie_shop_icon = preload("res://Shop_Icons/tank_cookie_shop_icon.tscn")
var vampire_cookie_shop_icon = preload("res://Shop_Icons/vampire_cookie_shop_icon.tscn")
var puff_cookie_shop_icon = preload("res://Shop_Icons/puff_cookie_shop_icon.tscn")
var range_cookie_shop_icon = preload("res://Shop_Icons/range_cookie_shop_icon.tscn")

var unit_percentage = [[0,80], [80,100], [0,0], [0,0], [0,0]]

# Called when the node enters the scene tree for the first time.
func _ready():
	timer = get_node("Timer/Timer")
	timer.start()
	_random_shop_generator()
	
	unit_percentage = [[0,80], [80,100], [0,0], [0,0], [0,0]]
	
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
	
	if Input.is_action_just_pressed("pause"):
		if global.paused:
			resume()
		else:
			pause()


func pause():
	global.paused = true
	$Pause.show()
	$Timer/Timer.set_paused(true)


func resume():
	global.paused = false
	$Pause.hide()
	$Timer/Timer.set_paused(false)


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
		timer.start(10)


func scene_reset():
	global.gold += 3
	# Spawns the milk enemies
	if global.round == 2:
		var milk_pos = [Vector2(430, 250), Vector2(1300, 250), Vector2(730, 250), Vector2(1000, 250)]
		unit_percentage = [[0,60], [60,80], [80,100], [0,0], [0,0]]
		for i in milk_pos:
			var milk_temp = milk.instantiate()
			milk_temp.position = i
			get_node("Milks").add_child(milk_temp)
			global.milk_list.append(milk_temp)
	elif global.round == 3:
		var milk_pos = [Vector2(430, 250), Vector2(1300, 250), Vector2(630, 250), 
						Vector2(1100, 250), Vector2(830, 200), Vector2(900, 200)]
		unit_percentage = [[0,40], [40,60], [60,80], [80,100], [0,0]]
		for i in milk_pos:
			var milk_temp = milk.instantiate()
			milk_temp.position = i
			milk_temp.damage = 35
			get_node("Milks").add_child(milk_temp)
			global.milk_list.append(milk_temp)
	elif global.round == 4:
		var milk_pos = [Vector2(430, 250), Vector2(1300, 250), Vector2(630, 250), 
						Vector2(1100, 250), Vector2(830, 200), Vector2(900, 200)]
		unit_percentage = [[0,20], [40,60], [60,80], [80,90], [90,100]]
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
		unit_percentage = [[0,10], [10,30], [30,60], [60,80], [80,100]]
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
		var randInt = rng.randi_range(0, 99)
		if unit_percentage[0][0] <= randInt and randInt < unit_percentage[0][1]:
			var fighter_cookie_temp = fighter_cookie_shop_icon.instantiate()
			fighter_cookie_temp.position = Vector2(x,912)
			get_node("Shop").add_child(fighter_cookie_temp)
		elif unit_percentage[1][0] <= randInt and randInt  < unit_percentage[1][1]:
			var tank_cookie_temp = tank_cookie_shop_icon.instantiate()
			tank_cookie_temp.position = Vector2(x,912)
			get_node("Shop").add_child(tank_cookie_temp)
		elif unit_percentage[2][0] <= randInt and randInt  < unit_percentage[2][1]:
			var vampire_cookie_temp = vampire_cookie_shop_icon.instantiate()
			vampire_cookie_temp.position = Vector2(x,912)
			get_node("Shop").add_child(vampire_cookie_temp)
		elif unit_percentage[3][0] <= randInt and randInt  < unit_percentage[3][1]:
			var puff_cookie_temp = puff_cookie_shop_icon.instantiate()
			puff_cookie_temp.position = Vector2(x,912)
			get_node("Shop").add_child(puff_cookie_temp)
		elif unit_percentage[4][0] <= randInt and randInt  < unit_percentage[4][1]:
			var range_cookie_temp = range_cookie_shop_icon.instantiate()
			range_cookie_temp.position = Vector2(x,912)
			get_node("Shop").add_child(range_cookie_temp)


func _on_resume_button_pressed():
	resume()


func _on_main_menu_button_pressed():
	get_tree().change_scene_to_file("res://Main_Scenes/menu.tscn")
