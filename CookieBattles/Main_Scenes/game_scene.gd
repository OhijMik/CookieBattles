extends Node2D

var timer
var milk = preload("res://Milks/milk.tscn")
var saved_cookies = {}


# Called when the node enters the scene tree for the first time.
func _ready():
	timer = get_node("Timer/Timer")
	timer.start()
	
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
		for i in global.cookie_list:
			i.position = i.initial_pos
			saved_cookies[i] = i.position
		
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
	for i in saved_cookies:
		i.position = saved_cookies[i]
		i.get_node("CollisionShape2D").set_disabled(false)
		i.visible = true
		i.hp = i.initial_hp
		i.rotation = 0
	
	if global.round == 2:
		global.gold += 2
		var milk_pos = [Vector2(430, 250), Vector2(1300, 250), Vector2(730, 250), Vector2(1000, 250)]
		for i in milk_pos:
			var milk_temp = milk.instantiate()
			milk_temp.position = i
			get_node("Milks").add_child(milk_temp)
			global.milk_list.append(milk_temp)


func _on_reroll_button_pressed():
	if global.game_state == "prepare" and global.gold >= 2:
		global.gold -= 2
