extends Node2D

var timer

# Called when the node enters the scene tree for the first time.
func _ready():
	timer = get_node("Timer") 
	timer.start()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if not timer.is_stopped():
		get_node("TimerText").text = str(global.game_state) + ": " + str(round(timer.get_time_left()))


func _on_timer_timeout():
	timer.stop()
	if global.game_state == "prepare":
		timer.set_wait_time(30)
		global.game_state = "battle"
		timer.start()
	elif global.game_state == "battle":
		timer.set_wait_time(2)
		global.game_state = "conclusion"
		timer.start()
